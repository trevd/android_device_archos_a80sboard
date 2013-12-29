/*
 * Copyright (C) 2013 Trevor Drake ( trevd1234 at gmail.com )
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Name         : Archos G9 SDE boot image creator
 * Description  : An opensource replacement for kd_flasher.
 *                For use with the AOSP Android Build System
 *                a custom mkbootimg binary
 *	
 */

#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
/* Archos use a custom "Rawfs file system" to store their
 * Boot images - This is normally mounted at /mnt/rawfs
 * The SDE boot image is stored in /mnt/rawfs/custom
 * 
**
** +-----------------+ 
** | boot header     | 0x100 [ 256 ] bytes
** +-----------------+
** | kernel          | 
** +-----------------+
** | ramdisk         | 
** +-----------------+
** | padding         | 
** +-----------------+
**/

#define BOOT_MAGIC "\xF0\x89\xE5\xDA"
#define BOOT_MAGIC_SIZE 4

#define BOOT_HEADER_SIZE 0x100 // 256


typedef struct sde_img_hdr sde_img_hdr;

struct sde_img_hdr {
		char magic[BOOT_MAGIC_SIZE] ;
		char unused[0x90];
		unsigned ramdisk_start ; 
		unsigned ramdisk_size ;
		char unused2[0x64];
} ;

int usage(void)
{
    fprintf(stderr,"usage: mkbootimg\n"
            "       --kernel <filename>\n"
            "       --ramdisk <filename>\n"
            "       [ --image_size <image_size>  ]\n"
            "       -o|--output <filename>\n"
            );
    return 1;
}

static const unsigned hdr_size = sizeof(sde_img_hdr);

// There is a time and a place for using a macro with goto's
// and this is it!! 
#define die_memory(message) { \
		fprintf(stderr,"Cannot allocate %s memory\n", message); \
		goto cleanup_and_die; \
	}

#define free_memory(buffer) if(buffer) free(buffer)


int main(int argc, char *argv[]){
	   
	struct stat sbkernel,sbramdisk;
	int exitcode = EXIT_FAILURE ;
	
	char *kernel_fn = 0;
	char *ramdisk_fn = 0;
	char *bootimg = 0;
	int maxsize = 0;
  
	argc--;
    argv++;
	while(argc > 0){
        char *arg = argv[0];
        char *val = argv[1];
        if(argc < 2) {
				fprintf(stderr, "Usage:\n");
            return usage();
        }
        argc -= 2;
        argv += 2;
        if(!strcmp(arg, "--output") || !strcmp(arg, "-o")) {
            bootimg = val;
        } else if(!strcmp(arg, "--kernel")) {
            kernel_fn = val;
        } else if(!strcmp(arg, "--ramdisk")) {
            ramdisk_fn = val;
        } else if(!strcmp(arg,"--image_size")) {
            maxsize = atoi(val);
			}else if((!strcmp(arg, "--second")) ||
						(!strcmp(arg, "--cmdline")) ||
						(!strcmp(arg, "--base")) ||
						(!strcmp(arg, "--kernel_offset")) ||
						(!strcmp(arg, "--ramdisk_offset")) ||
						(!strcmp(arg, "--second_offset")) ||
						(!strcmp(arg, "--tags_offset")) ||
						(!strcmp(arg, "--board")))  {
					// silently disregard the unsupported switches
        } else {
			fprintf(stderr, "Usage1:%s\n",arg);
            return usage();
        }
    }


//if (argc != 5) {
	//	   fprintf(stderr, "Usage: %s --<kernel> <ramdisk> <maxsize> <output>\n", argv[0]);
		 //  exit(exitcode);
	  // }

   // Get the kernel file size 
   if (stat( kernel_fn , &sbkernel) == -1) {
		   perror("Cannot Stat Kernel File");
		   exit(exitcode);
	}
	// Get the ramdisk file size
	if (stat( ramdisk_fn , &sbramdisk) == -1) {
		   perror("Cannot Stat Ramdisk File");
		   exit(exitcode);
	}
		
	// calculate the size of the content to be written
	int datasize = sbkernel.st_size + sbramdisk.st_size + hdr_size ;
	
	if(maxsize<=0){
		fprintf(stderr,"Warning maxsize not set image\n"\
							"This may causing flashing to fail\n"\
							"if the image size > destination\n");
		maxsize = datasize ; 
	}else if (maxsize < datasize) {
		
		perror(
					"Boot Image is to big!!\n"\
					 "You can normally reduce the size of your kernel and ramdisk\n"\
					 "by choosing a different compression method\n"\
					 "LZMA provides the best compression");
					 
		exit(exitcode);
	}

	// Calculate the padding required this can be zero if the
	// max size hasn't been set
	int padding_buffer_length = maxsize-datasize; 
	if(padding_buffer_length<0){
		perror("Congratulations! You have broken this in a special way");
		exit(exitcode);
	}
	
	// Print Size information
	fprintf(stderr,"sizeof(sde_img_hdr)=%d!!\n",hdr_size);
	fprintf(stderr,"Kernel File : %s  Size: %lld!!\n", kernel_fn ,sbkernel.st_size);
	fprintf(stderr,"Ramdisk File : %s Size: %lld!!\n", ramdisk_fn ,sbramdisk.st_size);
	
	if(padding_buffer_length>0)	
		fprintf(stderr,"Padding Length : %d!!\n",padding_buffer_length);
	
	if(maxsize>0)	
		fprintf(stderr,"Max Image Size : %d!!\n", maxsize);
	
	
	// allocate the memory needed for the header
	sde_img_hdr* hdr = calloc(hdr_size,1);
	if (!hdr) die_memory("header");
		
	// allocate a memory buffers to receive input files
	unsigned char* kernel_buffer = calloc(sbkernel.st_size,1);
	if (!kernel_buffer) die_memory("kernel buffer");
	
	unsigned char* ramdisk_buffer = calloc(sbramdisk.st_size,1);
	if (!kernel_buffer) die_memory("ramdisk buffer");
	
	// allocate the zero'd padding_buffer
	unsigned char* padding_buffer = calloc(padding_buffer_length,1);
	if (!padding_buffer) die_memory("padding buffer");
	
	// copy the magic value into the header
	memcpy(hdr->magic, BOOT_MAGIC, BOOT_MAGIC_SIZE);
	
	// set the ramdisk start position this is the 
	// kernel size + the header size
	hdr->ramdisk_start = hdr_size + sbkernel.st_size;
	
	// The only other field in the header is the ramdisk size
	hdr->ramdisk_size = sbramdisk.st_size;
	
	int fd  = open(kernel_fn ,O_RDONLY);
	if (fd<0){
		fprintf(stderr,"Error:Cannot Open Kernel %s!!\n", kernel_fn );
		goto cleanup_and_die_file;
	}
	int bytes = read(fd,kernel_buffer,sbkernel.st_size);
	if(bytes<0){
		fprintf(stderr,"Error Reading kernel file [%s] : read returns %d!!\n",kernel_fn  ,bytes);
		goto cleanup_and_die_file;
	}
	close(fd);
	
	// open and read ramdisk data
	fd  = open(ramdisk_fn,O_RDONLY);
	if (fd<0){
		fprintf(stderr,"Error:Cannot Open Ramdisk %s!!\n",ramdisk_fn);
		goto cleanup_and_die_file;
	}
	bytes = read(fd,ramdisk_buffer,sbramdisk.st_size);
	if(bytes<0){
		fprintf(stderr,"Error Reading ramdisk file [%s] : read returns %d!!\n",ramdisk_fn  ,bytes);
		goto cleanup_and_die_file;
	}
	close(fd);
	
	// Write the output file
	fd  = creat(bootimg,  0644 );
	if (fd<0){
		fprintf(stderr,"Error:Cannot Create Output File %s!!\n",bootimg);
		goto cleanup_and_die_file;		
	}
	
	write(fd,hdr,sizeof(sde_img_hdr));
	write(fd,kernel_buffer,sbkernel.st_size);
	write(fd,ramdisk_buffer,sbramdisk.st_size);
	write(fd,padding_buffer,padding_buffer_length);
	exitcode = EXIT_SUCCESS ; 
	
cleanup_and_die_file: if(fd) close(fd);
	
cleanup_and_die:
	free_memory(hdr);
	free_memory(kernel_buffer);
	free_memory(ramdisk_buffer);
	free_memory(padding_buffer);
	exit(exitcode);
}
	