#
# Copyright 2013 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
BUILD_SPEC_CHOICES=

function print_build_spec_menu()
{
    local uname=$(uname)
    echo
    echo "You're building on" $uname
    echo
    echo "Build Specs Choices:"

    local i=1
    local choice
    for choice in ${BUILD_SPEC_CHOICES[@]}
    do
		PROD=`grep -o "^TARGET_PRODUCT.*:=.*" $choice | cut -f2 -d=`
		VARI=`grep -o "^TARGET_BUILD_VARIANT.*:=.*" $choice | cut -f2 -d=`
		TYPE=`grep -o "^TARGET_BUILD_TYPE.*:=.*" $choice | cut -f2 -d=`
		echo -n "      $i $PROD"
		test ! -z "$VARI"  && echo -n "-$VARI"
		test ! -z "$TYPE"  && echo -n "-$TYPE"
        #echo "     $i. `cut -f -d: $choice`"
        i=$(($i+1))
    done
	echo
}
function select_build_spec()
{
    rm $PWD/buildspec.mk
    local answer
    BUILD_SPEC_CHOICES=`find $PWD/device/*/*/buildspecs -mindepth 1 -maxdepth 1 -type f -iname "buildspec.mk.*" `
	test -z ${BUILD_SPEC_CHOICES[0]}  && return 1
    
    print_build_spec_menu
	echo -n "Which would you like? [] "
	read answer
	echo
    

    local selection=

    if [ -z "$answer" ]
    then
        selection=
    elif (echo -n $answer | grep -q -e "^[0-9][0-9]*$")
    then
        if [ $answer -le ${#BUILD_SPEC_CHOICES[@]} ]
        then
            selection=${BUILD_SPEC_CHOICES[$(($answer-1))]}
        fi
    elif (echo -n $answer | grep -q -e "^[^\-][^\-]*-[^\-][^\-]*$")
    then
        selection=$answer
    fi

	
    if [ -z "$selection" ]
    then
        return 1
    else
		cp $selection $PWD/buildspec.mk
    fi
	echo
    fixup_common_out_dir

    set_stuff_for_environment
    printconfig
    echo
}

#\					-exec sh -c "grep -oH \"^TARGET_PRODUCT.*:=.*\" {} |  sed 's/TARGET_PRODUCT.*:=//g' " \;`


select_build_spec					

add_lunch_combo aosp_a80sboard-userdebug
add_lunch_combo omni_a80sboard-userdebug
add_lunch_combo cm_a80sboard-userdebug
add_lunch_combo aosp_a80sboard-eng
add_lunch_combo omni_a80sboard-eng
add_lunch_combo cm_a80sboard-eng

