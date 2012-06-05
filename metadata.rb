maintainer       "KC Braunschweig"
maintainer_email "kcbraunschweig@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures cycleserver"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ java }.each do |cb|
  depends cb
end

%w{ centos redhat fedora scientific amazon }.each do |os|
  supports os
end

recipe "cycleserver::grill", "Installs and configures Grill"