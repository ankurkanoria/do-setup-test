# 3. Node Specific Config
#!/bin/bash
## Variables
id=1
nodename=`hostname`
PRIVATE_IP=$(curl http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

## edit /etc/hosts
sed -i.bak /$nodename/d /etc/hosts
tee -a /etc/hosts <<EOL

#Cluster
$PRIVATE_IP $nodename
EOL

## Zookeeper Conf
echo $id | tee -a /var/lib/zookeeper/myid
echo clientPortAddress=$nodename | tee -a /etc/zookeeper/conf/zoo.cfg
tee -a /etc/zookeeper/conf/zoo.cfg > /dev/null << EOL
#Zookeeper Server Ensemble
server.1=$nodename:2888:3888
EOL

systemctl restart network

## Mesos Conf
private_ip=`getent ahostsv4 $nodename | cut -d' ' -f1 | head -1`
echo $private_ip | tee /etc/mesos-master/ip
echo $private_ip | tee /etc/mesos-slave/ip
echo 1 | tee /etc/mesos-master/quorum
echo zk://$nodename:2181/mesos | tee /etc/mesos/zk

## Marathon Conf
mkdir -p /etc/marathon/conf
echo $private_ip | tee /etc/marathon/conf/http_address

## Start Services
systemctl start zookeeper
systemctl start mesos-master
systemctl start mesos-slave
systemctl start marathon