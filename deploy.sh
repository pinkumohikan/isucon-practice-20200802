#!/bin/bash -xe
cd /opt/isucon3-mod
git checkout $1
git pull
make restart
