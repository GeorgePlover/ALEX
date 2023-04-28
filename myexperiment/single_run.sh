#!/bin/bash

# lognormal-190M
# longitudes-200M
# longlat-200M
# ycsb-200M

../build/benchmark \
--keys_file=../test_data_used_in_paper/longlat-200M.bin.data \
--keys_file_type=binary \
--init_num_keys=100000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.05 \
--lookup_distribution=zipf \
--time_limit=0.1 \


