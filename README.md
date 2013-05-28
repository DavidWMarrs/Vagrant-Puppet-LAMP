Vagrant-Puppet-LAMP
===================

Puppet provisioner for a Linux (Ubuntu Lucid Lynx 32-bit), Apache, MySQL & PHP (5) stack.

Constructed using Puppet Lab's own modules from the Puppet Forge:

apache - http://forge.puppetlabs.com/puppetlabs/apache - version 0.4.0
firewall - http://forge.puppetlabs.com/puppetlabs/firewall - version 0.0.4
mysql - http://forge.puppetlabs.com/puppetlabs/mysql - version 0.5.0
stdlib - http://forge.puppetlabs.com/puppetlabs/stdlib - version 3.1.1

Each module is within this repository as a git submodule, checked out at the relevant version tag. Newer versions are available but have not yet been tested in this project.