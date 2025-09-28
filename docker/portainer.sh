#!/bin/bash

build(){
    from="docker-compose${1:-""}.yml"
    to="docker-compose${1:-""}.portainer.yml"
    cp $from $to
    sed -i 's/\.env/stack.env/g' $to
    echo "build $to"
}

case "$1" in
    build)
        build $2
        ;;
    *)
        echo "Usage: $0 {build}"
        exit 1
        ;;
esac