#!/bin/bash

ip_node_split() {
    v1=()
    v2=()
    for i in {1..3}
    do
            x=${!i}
            f=($x)
            v1+=(${f[0]})
            v2+=(${f[1]})
    done
    echo "${v1[@]};${v2[@]}"
}

x1=`ssh -oStrictHostKeyChecking=no root@$1 \
    'echo $(hostname) $(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)'`
x2=`ssh -oStrictHostKeyChecking=no root@$2 \
    'echo $(hostname) $(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)'`
x3=`ssh -oStrictHostKeyChecking=no root@$3 \
    'echo $(hostname) $(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)'`
ip_node_split "$x1" "$x2" "$x3"
