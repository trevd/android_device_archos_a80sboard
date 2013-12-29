/*
 * Copyright (C) 2011 The Android Open Source Project
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
 */
#include <stdio.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>

#include "edify/expr.h"


#define MOUNT_LOCATION "/dev/block/mmcblk0p1"
#define RAWFS_MOUNT_POINT "/tmp/rawfs"
#define RAWFS_CUSTOM_FILENAME RAWFS_MOUNT_POINT"custom"

static inline int return_error(char* message) {
	printf(message);
	return -1 ;
}

static inline int write_custom_file(char* filename)
{
	struct stat source,dest;
	int wrote = 0 ; 
	
   // Get the boot image source file size 
   if (stat(filename, &source) == -1) 
		return return_error("Cannot Stat source File");
		   
	// Get the destination file size
	if (stat( RAWFS_CUSTOM_FILENAME , &dest) == -1) 
		  return return_error("Cannot Stat destination File");
	
	if (source.st_size > dest.st_size )
		   return return_error("Source File is Too Big!");
	
	int fd  = open(filename,O_RDONLY);
	if (fd<0){
		return return_error("Error:Cannot Open source file!!\n");
		
	}
	
	// allocate a buffer which fits the destination
	char* buffer = calloc(dest.st_size,1);
	if(!buffer){
		fprintf(stderr,"Error: Allocating memory!!\n");
		goto cleanup_and_die;
	}
	
	// mmap the full source file
	buffer = mmap(NULL, source.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (buffer == MAP_FAILED) {
		fprintf(stderr,"Error: loading file!!\n"	);
		goto cleanup_and_die;
	}
	close(fd);
	
	if ((fd = open(RAWFS_CUSTOM_FILENAME,  O_WRONLY )) < 0 ){
		fprintf(stderr,"Error:Cannot Open Output File %s!!\n",RAWFS_CUSTOM_FILENAME);
		goto cleanup_and_die;		
	}
	wrote = write(fd,buffer,dest.st_size);
		
cleanup_and_die:
	close(fd);
	if(buffer) munmap(buffer, dest.st_size);
	return wrote ; 
	
}

// write_sde_image(sde_boot_image)
Value* WriteSDEImage(const char* name, State* state, int argc, Expr* argv[]) {

    char* sdeImage;
    int wrote = 0;

    if (argc != 1)
        return ErrorAbort(state, "%s() expects 1 arg, got %d", name, argc);

    if (ReadArgs(state, argv, 1, &sdeImage) != 0) {
        return NULL;
    }
	mkdir(RAWFS_MOUNT_POINT, 0755);
	
	 if (mount(MOUNT_LOCATION, RAWFS_MOUNT_POINT, "rawfs",
                  MS_NOATIME | MS_NODEV | MS_NODIRATIME, "") < 0) {
            printf("%s: failed to mount %s: %s\n",
                   MOUNT_LOCATION, RAWFS_MOUNT_POINT, strerror(errno));
            
			goto done;
	} 
	
	printf("mounted: %s @ %s\n",MOUNT_LOCATION, RAWFS_MOUNT_POINT);
	  wrote =  write_custom_file(sdeImage);
    if (wrote <= 0) {
        printf("Failed to write sde image %s!\n",sdeImage);
    } else {
        printf("sde image written!\n");
    }
	 if(umount(RAWFS_MOUNT_POINT))
		 rmdir(RAWFS_MOUNT_POINT);
	
done:
    return StringValue(strdup(wrote > 0 ? "t" : ""));
}

void Register_librecovery_updater_a80sboard() {
    printf("Register_librecovery_updater_a80sboard is called\n");
    RegisterFunction("archos.write_sde_image", WriteSDEImage);
}
