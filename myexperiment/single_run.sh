#!/bin/bash

# lognormal-190M
# longitudes-200M
# longlat-200M
# ycsb-200M
# binom-200M

./run.sh binom-200M 200000000 5e6
./run.sh binom-200M 200000000 1e7
./run.sh binom-200M 200000000 2e7
./run.sh binom-200M 200000000 100000000


