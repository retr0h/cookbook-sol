Description
===========

Installs/Configures sol (Serial Over LAN)

Configures GRUB to redirect the serial port to ttyS1 (configurable).  Intended for serial port logging via [conserver](http://www.conserver.com) or similar.

Requirements
============

* Chef 0.8+
* GRUB 2

reboot-handler
----

Installs/Configures reboot-handler

Attributes
==========

* default['sol']['tty']['conf'] - Path to `node['sol']['tty']['name']`'s getty config file.
* default['sol']['tty']['name'] - Name of tty to use.

Reference the [wiki](https://help.ubuntu.com/community/Grub2) for tuning the following GRUB attributes.

* default['sol']['grub']['conf'] - Path to GRUB 2's default configuration.
* default['sol']['grub']['default']
* default['sol']['grub']['hidden_timeout']
* default['sol']['grub']['hidden_timeout_quiet']
* default['sol']['grub']['timeout']
* default['sol']['grub']['cmdline_linux_default'] 

The following serial port settings were tuned via an IPMI v2.0 Compliant KVM on a Quanta S99k.

* default['sol']['serial']['speed'] - The speed of the serial link in bits per second.
* default['sol']['serial']['unit'] - The number of the serial port, counting from zero.
* default['sol']['serial']['word'] - The (byte or character) of data you send or receive.
* default['sol']['serial']['parity'] - The number of parity bits.
* default['sol']['serial']['stop'] -  The number of stop bit-times.

* default['sol']['bios']['serial_port_mode'] - Serial port mode setting.  BIOS speed should match this value.

Usage
=====

```json
"run_list": [
    "recipe[curl]"
]
```

default
----

Installs/Configures sol

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
