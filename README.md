Description
===========

This cookbook installs and configures CycleComputing's CycleServer. Currently only the standalone version of the Grill
component is supported. For more information about CycleServer and Grill, see http://www.cyclecomputing.com/grill

The canonical source for this cookbook is: https://github.com/kcbraunschweig/cycleserver

Requirements
============

The cookbook has been tested on RHEL 5.7 and should work on any RedHat style linux. The only thing distro-specific is
the use of init/chkconfig so hopefully it will support other distros in a future version.

Attributes
==========
See `attributes/grill.rb` for all default values.

* `node["cycle_server"]["grill"]["url"]` - URL to download the Grill tarball from your private repository
* `node["cycle_server"]["grill"]["checksum"]` - SHA256 checksum of the Grill tarball
* `node["cycle_server"]["grill"]["include_java"]` - Enable/disable including and using the community Java cookbook
* `node["cycle_server"]["grill"]["manage_user"]` - Enable/disable managing the user that will run Grill
* `node["cycle_server"]["grill"]["user"]` - The user that will run Grill
* `node["cycle_server"]["grill"]["group"]` - Group for the user that will run Grill
* `node["cycle_server"]["grill"]["webServerMaxHeapSizeMB"]` - Default `768`
* `node["cycle_server"]["grill"]["databaseMaxHeapSizeMB"]` - Default `256`
* `node["cycle_server"]["grill"]["brokerMaxHeapSizeMB"]` - Default `96`
* `node["cycle_server"]["grill"]["maxActiveDatabaseConnections"]` - Default `25`
* `node["cycle_server"]["grill"]["brokerJmxPort"]` - Default `nil`, set to an integer to enable on that port

Usage
=====

Grill requires 2 pieces of manual configuration and then will configure a basic Grill server out of the box. These are
private download locations for the Grill tarball and Oracle Java. This is because each requires manual actions on a web
page to download. Once you've downloaded them to your private repository, you may want to configure Grill with a role
like the example below.

Once Grill is up and running, point your browser at port 8080 and complete the configuration via the Grill webui.

Role example:

`grill_server.rb`

```
name 'grill_server'
description 'CycleServer Grill Server'

run_list(
    "recipe[cycleserver::grill]"
)

default_attributes(
  "cycle_server" => {
    "grill" => {
      "url" => "http://download.example.com/cycle_server-grill-1.5.tar.gz",
      "checksum" => "1925adab234c188f1cb55a54d34ca1668865ee72da16db15904669fc5a1f9d08"
    }
  },
  "java" => {
    "install_flavor" => "oracle",
    "jdk" => {
      "6" => {
        "x86_64" => {
          "url" => "http://download.example.com/jdk-6u32-linux-x64.bin",
          "checksum" => "269d05b8d88e583e4e66141514d8294e636f537f55eb50962233c9e33d8f8f49"
        }
      }
    }
  }
)
```

Note that Oracle Java is required and the above assumes you are using the community Java cookbook. If you have another
prefered method for providing Oracle Java for your environment, you can disable inclusion of the java recipe by setting
the `node["cycle_server"]["grill"]["include_java"]` attribute to `false` and adding your own method to the run_list.

You can also disable creation of the user/group that will run Grill by setting `node["cycle_server"]["grill"]["manage_user"]`
to `false`. You must still set the attributes for user and group and provide them on the system by your own method.


License and Author
==================

Author:: KC Braunschweig (<kcbraunschweig@gmail.com>)
Copyright:: 2012, KC Braunschweig

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and