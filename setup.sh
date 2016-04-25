#!/bin/bash
rpm -iv --replacepkgs --force glibc-2.15-60.el6.x86_64.rpm glibc-common-2.15-60.el6.x86_64.rpm
# fix yum
cd /etc/yum.repos.d/ && ls *.repo | xargs sed -i 's/https:/http:/g' 
yum install -y tk.x86_64
yum install -y xterm
