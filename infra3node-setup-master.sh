# 3. Node Specific Config
#!/bin/bash
## Variables
NODEVARS=(`echo $1 | cut -d';' -f1`)
PIPVARS=(`echo $1 | cut -d';' -f2`)
IDVAR=$2

NODENAME=(${NODEVARS[$IDVAR]})
PRVIP=(${PIPVARS[$IDVAR]})

## edit /etc/hosts
sed -i.bak /$NODENAME/d /etc/hosts
tee -a /etc/hosts <<EOL

#Cluster
${PIPVARS[0]} ${NODEVARS[0]}
${PIPVARS[1]} ${NODEVARS[1]}
${PIPVARS[2]} ${NODEVARS[2]}
EOL

## Zookeeper Conf
echo $IDVAR | tee -a /var/lib/zookeeper/myid
echo clientPortAddress=${NODENAME} | tee -a /etc/zookeeper/conf/zoo.cfg
tee -a /etc/zookeeper/conf/zoo.cfg > /dev/null << EOL
#Zookeeper Server Ensemble
server.1=${NODEVARS[0]}:2888:3888
server.2=${NODEVARS[1]}:2888:3888
server.3=${NODEVARS[2]}:2888:3888
EOL

systemctl restart network

## Mesos Conf
#private_ip=`getent ahostsv4 ${NODEVARS[$IDVAR]} | cut -d' ' -f1 | head -1`
echo $PRVIP | tee /etc/mesos-master/ip
echo $PRVIP | tee /etc/mesos-slave/ip
echo 2 | tee /etc/mesos-master/quorum
echo zk://$NODENAME:2181/mesos | tee /etc/mesos/zk

## Marathon Conf
mkdir -p /etc/marathon/conf
echo $PRVIP | tee /etc/marathon/conf/http_address

## Start Services
systemctl start zookeeper
systemctl start mesos-master
systemctl start marathon

systemctl disable mesos-slave