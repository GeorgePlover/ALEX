#!/bin/bash

# lognormal-190M
# longitudes-200M
# longlat-200M
# ycsb-200M

name=$1
total_key=$2
init_key=$3
int_key=${init_key} 
if [ "$init_key" == "5e6" ]; then
    int_key=5000000
fi
if [ "$init_key" == "1e7" ]; then
    int_key=10000000
fi
if [ "$init_key" == "2e7" ]; then
    int_key=20000000
fi
mkdir work_tests
mkdir work_tests/${name}

echo bulk_${init_key}

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${int_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.00 \
--lookup_distribution=zipf \
> ./work_tests/${name}/bulk${init_key}_insfrac00.txt

echo 1

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${int_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.05 \
--lookup_distribution=zipf \
\
> ./work_tests/${name}/bulk${init_key}_insfrac05.txt

echo 2

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${int_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.25 \
--lookup_distribution=zipf \
\
> ./work_tests/${name}/bulk${init_key}_insfrac25.txt

echo 3

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${int_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.50 \
--lookup_distribution=zipf \
\
> ./work_tests/${name}/bulk${init_key}_insfrac50.txt

echo 4

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${int_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.75 \
--lookup_distribution=zipf \
\
> ./work_tests/${name}/bulk${init_key}_insfrac75.txt

echo 5

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${int_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=0.95 \
--lookup_distribution=zipf \
\
> ./work_tests/${name}/bulk${init_key}_insfrac95.txt

echo 6

../build/benchmark \
--keys_file=../test_data_used_in_paper/"${name}".bin.data \
--keys_file_type=binary \
--init_num_keys="${int_key}" \
--total_num_keys="${total_key}" \
--batch_size=2000 \
--insert_frac=1.00 \
--lookup_distribution=zipf \
\
> ./work_tests/${name}/bulk${init_key}_insfrac100.txt

echo 7
echo done!