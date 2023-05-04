#!/bin/bash

# lognormal-190M
# longitudes-200M
# longlat-200M
# ycsb-200M

name=$1
total_key=$2
init_key=$3 

mkdir ${name}

echo bulk_${init_key}

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${init_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.00 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk${init_key}_insfrac00.txt

echo 1

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${init_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.05 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk${init_key}_insfrac05.txt

echo 2

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${init_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.25 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk${init_key}_insfrac25.txt

echo 3

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${init_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.50 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk${init_key}_insfrac50.txt

echo 4

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${init_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.75 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk${init_key}_insfrac75.txt

echo 5

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${init_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.95 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk${init_key}_insfrac95.txt

echo 6

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${init_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=1.00 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk${init_key}_insfrac100.txt

echo 7
echo done!