#!/bin/bash

# lognormal-190M
# longitudes-200M
# longlat-200M
# ycsb-200M

name=$1

mkdir ${name}

echo bulk_5e6

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=5000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.00 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk5e6_insfrac00.txt

echo 1

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=5000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.05 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk5e6_insfrac05.txt

echo 2

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=5000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.25 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk5e6_insfrac25.txt

echo 3

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=5000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.50 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk5e6_insfrac50.txt

echo 4

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=5000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.75 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk5e6_insfrac75.txt

echo 5

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=5000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.95 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk5e6_insfrac95.txt

echo 6

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=5000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=1.00 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk5e6_insfrac100.txt

echo 7

echo bulk_1e7

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=10000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.00 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk1e7_insfrac00.txt

echo 1

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=10000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.05 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk1e7_insfrac05.txt

echo 2

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=10000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.25 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk1e7_insfrac25.txt

echo 3

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=10000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.50 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk1e7_insfrac50.txt

echo 4

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=10000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.75 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk1e7_insfrac75.txt

echo 5

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=10000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.95 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk1e7_insfrac95.txt

echo 6

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=10000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=1.00 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk1e7_insfrac100.txt

echo 7

echo bulk_2e7

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=20000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.00 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk2e7_insfrac00.txt

echo 1

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=20000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.05 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk2e7_insfrac05.txt

echo 2

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=20000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.25 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk2e7_insfrac25.txt

echo 3

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=20000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.50 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk2e7_insfrac50.txt

echo 4

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=20000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.75 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk2e7_insfrac75.txt

echo 5

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=20000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=0.95 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk2e7_insfrac95.txt

echo 6

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys=20000000 \
--total_num_keys=200000000 \
--batch_size=2000 \
--insert_frac=1.00 \
--lookup_distribution=zipf \
--time_limit=1 \
> ./${name}/bulk2e7_insfrac100.txt

echo 7


echo done!