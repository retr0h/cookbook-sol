maintainer       "AT&T Services, Inc."
maintainer_email "jdewey@att.com"
license          "All rights reserved"
description      "Installs/Configures sol"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"

recipe           "sol", "Installs/Configures sol"

supports         "ubuntu", "= 12.04"

depends          "reboot-handler"
