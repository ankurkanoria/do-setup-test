#!/bin/bash
yum -y update
yum -y install java-1.8.0-openjdk-headless nano
rpm -Uvh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-2.noarch.rpm
yum -y install mesosphere-zookeeper mesos marathon
rpm --import http://nginx.org/keys/nginx_signing.key
tee /etc/yum.repos.d/nginx.repo <<EOL
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
EOL
yum -y install nginx