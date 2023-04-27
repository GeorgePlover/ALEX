// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

/*
 * Simple benchmark that runs a mixture of point lookups and inserts on ALEX.
 */

#include "../core/alex.h"

#include <iomanip>

#include "flags.h"
#include "utils.h"

// Modify these if running your own workload
#define KEY_TYPE double
#define PAYLOAD_TYPE double

/*
 * Required flags:
 * --keys_file              path to the file that contains keys
 * --keys_file_type         file type of keys_file (options: binary or text)
 * --init_num_keys          number of keys to bulk load with
 * --total_num_keys         total number of keys in the keys file
 * --batch_size             number of operations (lookup or insert) per batch
 *
 * Optional flags:
 * --insert_frac            fraction of operations that are inserts (instead of
 * lookups)
 * --lookup_distribution    lookup keys distribution (options: uniform or zipf)
 * --time_limit             time limit, in minutes
 * --print_batch_stats      whether to output stats for each batch
 */

void out_stats(alex::Alex<KEY_TYPE, PAYLOAD_TYPE> &index){
  std::cout<<"STATS:\n";
  std::cout<<"num_keys: "<<index.stats_.num_keys<<"\n";
  std::cout<<"num_model_nodes: "<<index.stats_.num_model_nodes<<"\n";
  std::cout<<"num_data_nodes: "<<index.stats_.num_data_nodes<<"\n";
  std::cout<<"num_expand_and_scales: "<<index.stats_.num_expand_and_scales<<"\n";
  std::cout<<"num_expand_and_retrains: "<<index.stats_.num_expand_and_retrains<<"\n";
  std::cout<<"num_downward_splits: "<<index.stats_.num_downward_splits<<"\n";
  std::cout<<"num_sideways_splits: "<<index.stats_.num_sideways_splits<<"\n";
  std::cout<<"num_downward_split_keys: "<<index.stats_.num_downward_split_keys<<"\n";
  std::cout<<"num_model_node_expansion_pointers: "<<index.stats_.num_model_node_expansion_pointers<<"\n";
  std::cout<<"num_model_node_split_pointers: "<<index.stats_.num_model_node_split_pointers<<"\n";
  std::cout<<"num_node_lookups: "<<index.stats_.num_node_lookups<<"\n";
  std::cout<<"num_lookups: "<<index.stats_.num_lookups<<"\n";
  std::cout<<"num_inserts: "<<index.stats_.num_inserts<<"\n";
  std::cout<<"splitting_time: "<<index.stats_.splitting_time<<"\n";
  std::cout<<"cost_computation_time: "<<index.stats_.cost_computation_time<<"\n\n";
}

/* 
Nodes:
  node_size()
  level_
ModelNodes:
  num_children_
DataNodes:
  data_capacity_  
  num_keys_
  num_shifts_
  num_exp_search_iterations_
  num_lookups_
  num_inserts_
  num_resizes_
  expected_avg_exp_search_iterations_
  expected_avg_shifts_
*/
std::multiset<short> set_level;
std::multiset<long long> set_data_node_size;
std::multiset<long long> set_model_node_size; 
std::multiset<int> set_num_children; // 模型结点的孩子个数
std::multiset<int> set_num_keys; //数据节点的键值个数
std::multiset<double> set_shifts_per_ins; // 每个插入的平均平移次数
std::multiset<double> set_iter_per_op; // 每个操作的平均搜索迭代次数
// std::multiset<double> set_p_shifts; // 真实移动代价/期望代价
// std::multiset<double> set_p_iter; //真实搜索迭代代价/期望代价
std::multiset<int> set_num_lookups; 
std::multiset<int> set_num_inserts;
std::multiset<int> set_num_shifts; 
std::multiset<int> set_num_iter;  

void Trave_Nodes(alex::AlexNode<KEY_TYPE, PAYLOAD_TYPE> *rt){
  set_level.insert(rt->level_);
  if(rt->is_leaf_){
    auto data_node = static_cast<alex::AlexDataNode<KEY_TYPE, PAYLOAD_TYPE>*>(rt);
    set_data_node_size.insert(data_node->node_size()+data_node->data_size());
    set_num_keys.insert(data_node->num_keys_);

    set_num_lookups.insert(data_node->num_lookups_); set_num_inserts.insert(data_node->num_inserts_);
    set_num_shifts.insert(data_node->num_shifts_); set_num_iter.insert(data_node->num_exp_search_iterations_);  

    set_shifts_per_ins.insert(static_cast<double> (data_node->num_shifts_)/data_node->num_inserts_);
    set_iter_per_op.insert(static_cast<double> (
      data_node->num_exp_search_iterations_)/(data_node->num_inserts_+data_node->num_lookups_));
  }
  else{
    auto model_node = static_cast<alex::AlexModelNode<KEY_TYPE, PAYLOAD_TYPE>*>(rt);

    set_model_node_size.insert(model_node->node_size());
    set_num_children.insert(model_node->num_children_);

    for(int i=0;i<model_node->num_children_;i++){
      if(model_node->children_[i] == nullptr)continue;
      Trave_Nodes(model_node->children_[i]);
      i+=(1<<(model_node->children_[i]->duplication_factor_))-1;
    }
  }
}

void get_info(alex::Alex<KEY_TYPE,PAYLOAD_TYPE> &index){
  set_level.clear();set_data_node_size.clear();set_model_node_size.clear();
  set_num_children.clear();set_num_keys.clear();set_shifts_per_ins.clear();
  set_num_lookups.clear(); set_num_inserts.clear();
  set_num_shifts.clear(); set_num_iter.clear();  

  Trave_Nodes(index.root_node_);

  long long total_size=0;
  long long total_lookups=0,total_inserts=0,total_exp_iter=0,total_shifts=0;
  for(auto &i: set_data_node_size)total_size+=i;
  for(auto &i: set_model_node_size)total_size+=i;
  for(auto &i: set_num_lookups)total_lookups+=i;
  for(auto &i: set_num_inserts)total_inserts+=i;
  for(auto &i: set_num_iter)total_exp_iter+=i;
  for(auto &i: set_num_shifts)total_shifts+=i;

  std::cout<<"Total size: "<< static_cast<double>(total_size)/(1024*1024) << "MB\n";
  std::cout<<"Max level: "<< *(--set_level.end()) << "\n";
  std::cout<<"Max model node size: "<< *(--set_model_node_size.end()) << "B\n";
  std::cout<<"Max data node size: "<< *(--set_data_node_size.end()) << "B\n";
  std::cout<<"Total exp-search iterations: "<< total_exp_iter << "\n";
  std::cout<<"Total shifts: "<< total_shifts << "\n";
}

int main(int argc, char* argv[]) {
  auto flags = parse_flags(argc, argv);
  std::string keys_file_path = get_required(flags, "keys_file");
  std::string keys_file_type = get_required(flags, "keys_file_type");
  auto init_num_keys = stoi(get_required(flags, "init_num_keys"));
  auto total_num_keys = stoi(get_required(flags, "total_num_keys"));
  auto batch_size = stoi(get_required(flags, "batch_size"));
  auto insert_frac = stod(get_with_default(flags, "insert_frac", "0.5"));
  std::string lookup_distribution =
      get_with_default(flags, "lookup_distribution", "zipf");
  auto time_limit = stod(get_with_default(flags, "time_limit", "0.5"));
  bool print_batch_stats = get_boolean_flag(flags, "print_batch_stats");

  // Read keys from file
  std::cout << "Loading keys from file...\n";
  auto keys = new KEY_TYPE[total_num_keys];
  if (keys_file_type == "binary") {
    load_binary_data(keys, total_num_keys, keys_file_path);
  } else if (keys_file_type == "text") {
    load_text_data(keys, total_num_keys, keys_file_path);
  } else {
    std::cerr << "--keys_file_type must be either 'binary' or 'text'"
              << std::endl;
    return 1;
  }
  std::cout << "[Loading keys from file] Done.\n";

  // Combine bulk loaded keys with randomly generated payloads
  auto values = new std::pair<KEY_TYPE, PAYLOAD_TYPE>[init_num_keys];
  std::mt19937_64 gen_payload(std::random_device{}());
  for (int i = 0; i < init_num_keys; i++) {
    values[i].first = keys[i];
    values[i].second = static_cast<PAYLOAD_TYPE>(gen_payload());
  }

  // Create ALEX and bulk load
  alex::Alex<KEY_TYPE, PAYLOAD_TYPE> index;
  std::sort(values, values + init_num_keys,
            [](auto const& a, auto const& b) { return a.first < b.first; });
  index.bulk_load(values, init_num_keys);

  // Run workload
  int i = init_num_keys;
  long long cumulative_inserts = 0;
  long long cumulative_lookups = 0;
  int num_inserts_per_batch = static_cast<int>(batch_size * insert_frac);
  int num_lookups_per_batch = batch_size - num_inserts_per_batch;
  double cumulative_insert_time = 0;
  double cumulative_lookup_time = 0;

  auto workload_start_time = std::chrono::high_resolution_clock::now();
  int batch_no = 0;
  PAYLOAD_TYPE sum = 0;


  out_stats(index);

  std::cout << "workload start.\n";
  std::cout << std::scientific;
  std::cout << std::setprecision(3);
  while (true) {
    batch_no++;

    // Do lookups
    double batch_lookup_time = 0.0;
    if (i > 0) {
      KEY_TYPE* lookup_keys = nullptr;
      if (lookup_distribution == "uniform") { 
        lookup_keys = get_search_keys(keys, i, num_lookups_per_batch);
      } else if (lookup_distribution == "zipf") {
        lookup_keys = get_search_keys_zipf(keys, i, num_lookups_per_batch);
      } else {
        std::cerr << "--lookup_distribution must be either 'uniform' or 'zipf'"
                  << std::endl;
        return 1;
      }
      auto lookups_start_time = std::chrono::high_resolution_clock::now();
      for (int j = 0; j < num_lookups_per_batch; j++) {
        KEY_TYPE key = lookup_keys[j];
        PAYLOAD_TYPE* payload = index.get_payload(key);
        if (payload) {
          sum += *payload;
        }
      }
      auto lookups_end_time = std::chrono::high_resolution_clock::now();
      batch_lookup_time = std::chrono::duration_cast<std::chrono::nanoseconds>(
                              lookups_end_time - lookups_start_time)
                              .count();
      cumulative_lookup_time += batch_lookup_time;
      cumulative_lookups += num_lookups_per_batch;
      delete[] lookup_keys;
    }

    // Do inserts
    int num_actual_inserts =
        std::min(num_inserts_per_batch, total_num_keys - i);
    int num_keys_after_batch = i + num_actual_inserts;
    auto inserts_start_time = std::chrono::high_resolution_clock::now();
    for (; i < num_keys_after_batch; i++) {
      index.insert(keys[i], static_cast<PAYLOAD_TYPE>(gen_payload()));
    }
    auto inserts_end_time = std::chrono::high_resolution_clock::now();
    double batch_insert_time =
        std::chrono::duration_cast<std::chrono::nanoseconds>(inserts_end_time -
                                                             inserts_start_time)
            .count();
    cumulative_insert_time += batch_insert_time;
    cumulative_inserts += num_actual_inserts;

    if (print_batch_stats) {
      int num_batch_operations = num_lookups_per_batch + num_actual_inserts;
      double batch_time = batch_lookup_time + batch_insert_time;
      long long cumulative_operations = cumulative_lookups + cumulative_inserts;
      double cumulative_time = cumulative_lookup_time + cumulative_insert_time;
      std::cout << "Batch " << batch_no
                << ", cumulative ops: " << cumulative_operations
                << "\n\tbatch throughput:\t"
                << num_lookups_per_batch / batch_lookup_time * 1e9
                << " lookups/sec,\t"
                << num_actual_inserts / batch_insert_time * 1e9
                << " inserts/sec,\t" << num_batch_operations / batch_time * 1e9
                << " ops/sec"
                << "\n\tcumulative throughput:\t"
                << cumulative_lookups / cumulative_lookup_time * 1e9
                << " lookups/sec,\t"
                << cumulative_inserts / cumulative_insert_time * 1e9
                << " inserts/sec,\t"
                << cumulative_operations / cumulative_time * 1e9 << " ops/sec"
                << std::endl;
    }

    // Check for workload end conditions
    if (num_actual_inserts < num_inserts_per_batch) {
      // End if we have inserted all keys in a workload with inserts
      break;
    }
    double workload_elapsed_time =
        std::chrono::duration_cast<std::chrono::nanoseconds>(
            std::chrono::high_resolution_clock::now() - workload_start_time)
            .count();
    if (workload_elapsed_time > time_limit * 1e9 * 60) {
      break;
    }
  }

  long long cumulative_operations = cumulative_lookups + cumulative_inserts;
  double cumulative_time = cumulative_lookup_time + cumulative_insert_time;
  std::cout << "Cumulative stats: " << batch_no << " batches, "
            << cumulative_operations << " ops (" << cumulative_lookups
            << " lookups, " << cumulative_inserts << " inserts)"
            << "\n\tcumulative throughput:\t"
            << cumulative_lookups / cumulative_lookup_time * 1e9
            << " lookups/sec,\t"
            << cumulative_inserts / cumulative_insert_time * 1e9
            << " inserts/sec,\t"
            << cumulative_operations / cumulative_time * 1e9 << " ops/sec"
            << std::endl;

  get_info(index);

  delete[] keys;
  delete[] values;
}
