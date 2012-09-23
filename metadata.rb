maintainer       "AT&T Services, Inc."
maintainer_email "jdewey@att.com"
license          "All rights reserved"
description      "Installs/Configures sol"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

recipe           "sol", "Installs/Configures sol"

%w{ ubuntu }.each do |os|
  supports os
end

depends "reboot-handler"
