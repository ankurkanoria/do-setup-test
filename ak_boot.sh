#!/bin/bash
yum -y update
yum -y install java-1.8.0-openjdk-headless
rpm -Uvh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-2.noarch.rpm
yum -y install mesosphere-zookeeper mesos marathon
systemctl disable zookeeper mesos-master mesos-slave marathon

echo 1 | tee -a /var/lib/zookeeper/myid
tee -a /etc/zookeeper/conf/zoo.cfg > /dev/null << EOL
#Zookeeper Server Ensemble
server.1=node1:2888:3888
server.2=node2:2888:3888
server.3=node3:2888:3888
EOL

private_ip=$(curl http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

echo zk://node1:2181,node2:2181,node3:2181/mesos | tee /etc/mesos/zk
echo $private_ip | tee /etc/mesos-master/ip
echo $private_ip | tee /etc/mesos-slave/ip
echo 2 | tee /etc/mesos-master/quorum

mkdir -p /etc/marathon/conf
#echo 127.0.0.1 | tee /etc/marathon/conf/http_address



#systemctl start zookeeper
#systemctl start mesos-master
#systemctl start mesos-slave
#systemctl start marathon