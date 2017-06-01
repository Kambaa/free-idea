#!/usr/bin/env bash
cd ./app/
./build.sh
cd -

if [ ! -f ./crack/app.tar ]; then
  echo "The project file is missing, please update it!" & exit 1
fi

docker rm -f free-idea
docker build --rm=true \
-t windomz/free-idea \
--file ./crack/Dockerfile ./crack
if [ $? -ne 0 ]; then
  exit 1
fi

port=25252
if [ -n "$(echo $1| sed -n "/^[0-9]\+$/p")" ];then
  port=$1
fi
docker run --restart=always \
-p ${port}:25252 \
--name free-idea -d windomz/free-idea

rm ./crack/app.tar
