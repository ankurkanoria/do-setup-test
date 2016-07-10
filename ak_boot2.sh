# 1. Node-agnostic setup startup-script
#!/bin/bash
yum -y update
yum -y install java-1.8.0-openjdk-headless nano
rpm -Uvh http://repos.mesosphere.io/el/7/noarch/RPMS/mesosphere-el-repo-7-2.noarch.rpm
yum -y install mesosphere-zookeeper mesos marathon
systemctl disable zookeeper mesos-master mesos-slave marathon

# 2. /etc/hosts needs to be setup
# x.x.x.x node1 node1
# y.y.y.y node2 node2
# z.z.z.z node3 node3

# 3. Node Specific Config
#!/bin/bash
## Variables
id=1
nodename=$(hostname)

## edit /etc/hosts
sed -i.bak /$nodename/d /etc/hosts
tee -a /etc/hosts <<EOL

#Cluster
10.139.0.182 centos-512mb-blr1-01 centos-512mb-blr1-01
10.139.0.137 centos-512mb-blr1-02 centos-512mb-blr1-02
10.139.0.202 centos-512mb-blr1-03 centos-512mb-blr1-03
EOL

## Zookeeper Conf
echo $id | tee -a /var/lib/zookeeper/myid
echo clientPortAddress=$nodename | tee -a /etc/zookeeper/conf/zoo.cfg
tee -a /etc/zookeeper/conf/zoo.cfg > /dev/null << EOL
#Zookeeper Server Ensemble
server.1=centos-512mb-blr1-01:2888:3888
server.2=centos-512mb-blr1-02:2888:3888
server.3=centos-512mb-blr1-03:2888:3888
EOL

systemctl restart network

## Mesos Conf
private_ip=$(getent ahostsv4 $nodename | cut -d' ' -f1 | head -1)
echo $private_ip | tee /etc/mesos-master/ip
echo $private_ip | tee /etc/mesos-slave/ip
echo 2 | tee /etc/mesos-master/quorum
echo zk://centos-512mb-blr1-01:2181,centos-512mb-blr1-02:2181,centos-512mb-blr1-03:2181/mesos | tee /etc/mesos/zk

## Marathon Conf
mkdir -p /etc/marathon/conf
#echo $private_ip | tee /etc/marathon/conf/http_address





#systemctl start zookeeper
#systemctl start mesos-master
#systemctl start mesos-slave
#systemctl start marathon