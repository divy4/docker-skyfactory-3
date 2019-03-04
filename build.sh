#!/bin/bash

export DOCKER_BUILDKIT=1

sudo docker build . -t divy4/docker-skyfactory-3:latest
sudo docker image ls
