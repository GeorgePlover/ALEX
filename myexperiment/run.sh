#!/bin/bash

# ../build/benchmark \
# --keys_file=../resources/sample_keys.bin \
# --keys_file_type=binary \
# --init_num_keys=500 \
# --total_num_keys=1000 \
# --batch_size=1000 \
# --insert_frac=0.5

# 
../build/benchmark \
--keys_file=../test_data_used_in_paper/longlat-200M.bin.data \
--keys_file_type=binary \
--init_num_keys=1000000 \
--total_num_keys=200000000 \
--batch_size=20 \
--insert_frac=0.05 \
--lookup_distribution=zipf \
--time_limit=1

