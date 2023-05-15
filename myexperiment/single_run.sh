#!/bin/bash

# lognormal-190M
# longitudes-200M
# longlat-200M
# ycsb-200M
# binom-200M

# ./run.sh longitudes-200M 200000000 5e6
# ./run.sh longitudes-200M 200000000 1e7
# ./run.sh longitudes-200M 200000000 2e7

# ./run.sh longlat-200M 200000000 5e6
# ./run.sh longlat-200M 200000000 1e7
# ./run.sh longlat-200M 200000000 2e7

# ./run.sh binom-200M 400000000 5e6
# ./run.sh binom-200M 400000000 1e7
# ./run.sh binom-200M 400000000 2e7

./run.sh ycsb-200M 200000000 5e6
./run.sh ycsb-200M 200000000 1e7
./run.sh ycsb-200M 200000000 2e7

./run.sh lognormal-190M 190000000 5e6
./run.sh lognormal-190M 190000000 1e7
./run.sh lognormal-190M 190000000 2e7

