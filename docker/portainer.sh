#!/bin/bash

build(){
    from="docker-compose$1.yml"
    to="docker-compose$1.portainer.yml"
    cp $from $to
    sed -i 's/\.env/stack.env/g' $to
    echo "build $to"
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


case "$1" in
    build)
        build "$2"
        ;;
    hwaccel)
        hwaccel "$2" ${3:-"transcoding"}
        ;;
    *)
        echo "Usage: $0 {build}"
        exit 1
        ;;
esac