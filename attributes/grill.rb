#
# Author:: KC Braunschweig (<kcbraunschweig@gmail.com>)
# Cookbook Name:: cycleserver
# Attributes:: grill
#
# Copyright 2012, KC Braunschweig
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default["cycle_server"]["grill"]["url"] = "http://download.example.com/cycleserver/cycle_server-grill-1.5.tar.gz"
default["cycle_server"]["grill"]["checksum"] = "1925adab234c188f1cb55a54d34ca1668865ee72da16db15904669fc5a1f9d08"
default["cycle_server"]["grill"]["include_java"] = true
default["cycle_server"]["grill"]["manage_user"] = true
default["cycle_server"]["grill"]["user"] = "cycleserver"
default["cycle_server"]["grill"]["group"] = "cycleserver"
default["cycle_server"]["grill"]["webServerMaxHeapSize"] = "768M"
default["cycle_server"]["grill"]["databaseMaxHeapSize"] = "256M"
default["cycle_server"]["grill"]["brokerMaxHeapSize"] = "96M"
default["cycle_server"]["grill"]["maxActiveDatabaseConnections"] = "25"
default["cycle_server"]["grill"]["brokerJmxPort"] = nil
