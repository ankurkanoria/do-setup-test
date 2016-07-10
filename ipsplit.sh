#!/bin/bash
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

