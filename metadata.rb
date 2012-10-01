maintainer       "John Dewey"
maintainer_email "john@dewey.ws"
license          "Apache 2.0"
description      "Installs/Configures cookbook-raid"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

recipe           "raid", "Installs/Configures raid"

supports         "ubuntu", "= 12.04"

depends          "reboot-handler"
depends          "megaraidcli"
depends          "parted"
depends          "rsync"
