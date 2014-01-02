# Copyright (C) 2012 The Android Open Source Project
# Copyright (C) 2012 The CyanogenMod Project
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

"""Custom OTA commands for p1"""

import common
import os

def FullOTA_InstallEnd(info):
  # Remove writing boot.img from script (we do it in updater.sh)
  info.script.script = [cmd for cmd in info.script.script if not "boot.img" in cmd]
  info.script.AppendExtra('archos.write_sde_image("boot.img");')

