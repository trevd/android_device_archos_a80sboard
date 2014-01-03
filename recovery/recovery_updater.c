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
#include <unistd.h>
#include <fcntl.h>
#include "minzip/Zip.h"
#include "updater/updater.h"
#include "mtdutils/mounts.h"
#include "edify/expr.h"

struct MountedVolume {
    const char *device;
    const char *mount_point;
    const char *filesystem;
    const char *flags;
};

extern Value* MountFn(const char* name, State* state, int argc, Expr* argv[]) ; 
extern Value* IsMountedFn(const char* name, State* state, int argc, Expr* argv[]);
extern Value* DeleteFn(const char* name, State* state, int argc, Expr* argv[]) ;
#define MOUNT_LOCATION "/dev/block/mmcblk0p1"
#define RAWFS_MOUNT_POINT "/rawfs"
#define RAWFS_CUSTOM_FILENAME RAWFS_MOUNT_POINT"/custom"

static inline int return_error(char* message) {
	printf(message);
	return -1 ;
}

static inline int mount_rawfs(){
	
	printf("mount_rawfs is called\n"); 
	
	errno = 0;
	if( mkdir(RAWFS_MOUNT_POINT,0777) < 0){
		if (errno != EEXIST ){
			printf("mount_rawfs is failed\n"); 
			return -1;
		}
	}	
	if (mount(MOUNT_LOCATION, RAWFS_MOUNT_POINT, "rawfs",MS_NOATIME | MS_NODEV | MS_NODIRATIME, "") < 0) {
            printf("%s: failed to mount %s: %s\n",MOUNT_LOCATION, RAWFS_MOUNT_POINT, strerror(errno));
            rmdir(RAWFS_MOUNT_POINT);
			return -1;
	} 
	printf("mounted: %s @ %s\n",MOUNT_LOCATION, RAWFS_MOUNT_POINT);
	return 0 ; 
}
// mount(fs_type, partition_type, location, mount_point)
Value* MountAndWipeFn(const char* name, State* state, int argc, Expr* argv[]) {
	
	printf("MountAndWipeFn is called\n"); 
	    char* result = NULL;
    if (argc != 4) {
        return ErrorAbort(state, "%s() expects 4 args, got %d", name, argc);
    }
	char* fs_type;
	char* partition_type;
	char* location;
	char* mount_point;
	if (ReadArgs(state, argv, 4, &fs_type, &partition_type,
				 &location, &mount_point) < 0) {
		return NULL;
	}
	    if (strlen(fs_type) == 0) {
        ErrorAbort(state, "fs_type argument to %s() can't be empty", name);
        goto done;
    }
    if (strlen(partition_type) == 0) {
        ErrorAbort(state, "partition_type argument to %s() can't be empty",
                   name);
        goto done;
    }
    if (strlen(location) == 0) {
        ErrorAbort(state, "location argument to %s() can't be empty", name);
        goto done;
    }
    if (strlen(mount_point) == 0) {
        ErrorAbort(state, "mount_point argument to %s() can't be empty", name);
        goto done;
    }

    char *secontext = NULL;

    if (sehandle) {
        selabel_lookup(sehandle, &secontext, mount_point, 0755);
        setfscreatecon(secontext);
    }
	
	Expr* ismounted_argv[] = { argv[3] }; //  mount_point
	Value* ismountedfn = IsMountedFn("is_mounted",state,1, ismounted_argv );
	Value* mountfn = NULL ;  
	printf("MountAndWipeFn :IsMountedFn is called\n"); 
	if((ismountedfn != NULL) && (strlen(ismountedfn->data) == 0)){
		mountfn = MountFn("mount",state,argc,argv); 
		printf("MountAndWipeFn :MountFn is called\n"); 
		if((mountfn == NULL) || (strlen(mountfn->data) == 0)){
			ErrorAbort(state,"Failed to mount %s\n",mount_point);
			goto done2;
		}
		
	}
	result = mount_point;
   Value* deletefn  = DeleteFn("delete_recursive",state,1, ismounted_argv );
	
done2: 
	if(mountfn)free(mountfn);
	if(ismountedfn)free(ismountedfn);
done:

    free(fs_type);
    free(partition_type);
    free(location);
    if (result != mount_point) free(mount_point);
    return StringValue(result);
}	

// write_sde_image(sde_boot_image)
Value* WriteSDEImageFn(const char* name, State* state, int argc, Expr* argv[]) {

   printf("WriteSDEImageFn is called\n"); 
	char* sdeImage;
	 struct stat dest;
    int success = 0;

    if (argc != 1)
        return ErrorAbort(state, "%s() expects 1 arg, got %d", name, argc);

    if (ReadArgs(state, argv, 1, &sdeImage) != 0)
        return NULL;
	
	// Umount any rawfs mounts
	scan_mounted_volumes();
   const MountedVolume* vol = find_mounted_volume_by_device(MOUNT_LOCATION);
	if(vol){
		printf("unmounting rawfs mounted at %s\n",vol->mount_point);
		unmount_mounted_volume(vol);
	}
		
	// Mount Rawfs at a mount temporary mount point
	// TODO : Work out what is required to write to the 
	// block device directly
	if(mount_rawfs()<0) 
		goto done;
		
	// Get the file size for /rawfs/custom
	if (stat( RAWFS_CUSTOM_FILENAME , &dest) == -1) {
		 printf("Cannot Stat destination File");
		goto done;
	
	}
	// find the sdeImage - Normally called boot.img
	ZipArchive* za = ((UpdaterInfo*)(state->cookie))->package_zip;
	const ZipEntry* entry = mzFindZipEntry(za, sdeImage);
	if (entry == NULL) {
		printf("%s: no %s in package\n", name, sdeImage);
		goto done;
	}
	long sde_size = mzGetZipEntryUncompLen(entry);
	if(sde_size > dest.st_size){
		printf("%s: %s is to large\n", name, sdeImage);
		goto done;
	}
	// allocate a buffer which fits the destination
	char* buffer = calloc(dest.st_size,1);
	if(!buffer){
		printf("Error: Allocating memory!!\n");
		goto done;
	}
	int zipsuccess = mzExtractZipEntryToBuffer(za, entry,(unsigned char *)buffer);
	// Write the output file
	int fd  = open(RAWFS_CUSTOM_FILENAME,O_WRONLY);
	if (fd<0){
		printf("Error:Cannot Create Output File %s!!\n",sdeImage);
		goto done2;		
	}
	
	long bytes = write(fd,buffer,dest.st_size);
	if ( bytes <= 0 ){
		printf("Error:Cannot Create Output File %s!!\n",sdeImage);
		goto done3;
	}
	
	printf("%s written - %ld!!\n",sdeImage,bytes);
	if(fsync(fd) == -1){
		printf("fsync failed Error: %d %s!!\n",errno,strerror(errno));
	}
	// Umount our rawfs mount
	int umount_result = umount2(RAWFS_MOUNT_POINT,MNT_DETACH);
	if(umount_result == -1){
		printf("unmount error %d %s\n",errno,strerror(errno));	
	}
	printf("unmounting rawfs mounted at %s result %d\n",RAWFS_MOUNT_POINT,umount_result);	
	if(umount_result == 0 ) 
		rmdir(RAWFS_MOUNT_POINT);
		
	success = 1 ; 
    
done3:
	close(fd);
done2:
	free(buffer);
done:
	 
	 free(sdeImage);
    return StringValue(strdup(success > 0 ? "t" : ""));
}

void Register_librecovery_updater_a80sboard() {
	printf("Register_librecovery_updater_a80sboard is called\n");
	RegisterFunction("archos.mount_and_wipe", MountAndWipeFn);
	RegisterFunction("archos.write_sde_image", WriteSDEImageFn);
}
