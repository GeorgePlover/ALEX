#!/bin/bash

# lognormal-190M
# longitudes-200M
# longlat-200M
# ycsb-200M




./run.sh lognormal-190M 190000000 100000000
./run.sh ycsb-200M 200000000 100000000
./run.sh longlat-200M 200000000 100000000
./run.sh longitudes-200M 200000000 100000000


