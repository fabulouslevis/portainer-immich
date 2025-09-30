#!/bin/bash

env(){
    from="docker-compose$1.yml"
    to="docker-compose$1.portainer.yml"
    cp $from $to
    sed -i 's/\.env/stack.env/g' $to
    echo "env $to"
}

hwaccel(){
    to="docker-compose$1.portainer.yml"
    key="hwaccel.$2.yml"
    line=$(grep -n $key $to | cut -d: -f1)
    start_line=$(expr $line - 1)
    end_line=$(expr $line + 1)
    sed -i "${start_line} s/# //" $to
    sed -i "${line} s/# //" $to
    sed -i "${end_line} s/# //" $to
    sed -i "${end_line} s/cpu/\${HWACCEL_${2^^}_SERVICE:-cpu}/" $to
    echo "hwaccel $2 enabled"
}

ml(){
    to="docker-compose$1.portainer.yml"
    key="ghcr.io/immich-app/immich-machine-learning"
    line=$(grep -n $key $to | cut -d: -f1)
    sed -i "${line} s/\${IMMICH_VERSION:-release}/\${IMMICH_VERSION:-release}\${MACHINE_LEARNING_SUFFIX:-}/" $to
    echo "ml $2 add suffix"
}


case "$1" in
    env)
        env "$2"
        ;;
    hwaccel)
        hwaccel "$2" ${3:-"transcoding"}
        ;;
    ml)
        ml "$2"
        ;;
    *)
        echo "Usage: $0 {env|hwaccel|ml}"
        exit 1
        ;;
esac