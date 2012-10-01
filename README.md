Description
===========

Installs/Configures raid

This cookbook is geared towards our immediate goals.  I would like to merge it
with a couple nice raid cookbooks by Afterglow.

* https://github.com/Afterglow/chef-raid
* https://github.com/Afterglow/raid_controllers_ohai

Requirements
============

* Chef 0.8+
* [reboot-handler](https://github.com/retr0h/cookbook-reboot-handler)
* [megaraidcli](https://github.com/retr0h/cookbook-megaraidcli)

Attributes
==========

The following defaults were tested against a "LSI MegaRAID SAS 2108" on a Quanta S99k.

* default['raid']['megaraid']['adapter'] - The adapter to use.
* default['raid']['megaraid']['enclosure_id'] - The enclosures id.
* default['raid']['megaraid']['disks'] - `Array` of `Array` of disks to configure (e.g. [[0,1],[2,3]]).
* default['raid']['megaraid']['spares'] - `Array` of disks to configure as spares.
* default['raid']['megaraid']['options'] - Array options (e.g. Write Back or stripe size).
* default['raid']['raw_device'] - Array's raw device.
* default['raid']['block_device'] - Array's block device.
* default['raid']['mount'] - Array's mount point.
* default['raid']['fs'] - Array's file system type.

Usage
=====

```json
"run_list": [
    "recipe[raid]"
]
```

default
----

Installs/Configures raid

License and Author
==================

Author:: John Dewey (<john@dewey.ws>)

Copyright 2012, John Dewey

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and 
limitations under the License.
