#!/bin/bash -xe
ssh  isucon-app-1 /opt/isucon3-mod/deploy.sh $1 & \
ssh  isucon-app-2 /opt/isucon3-mod/deploy.sh $1
