
import itertools

DataSets = ["lognormal-190M","longitudes-200M","longlat-200M","ycsb-200M"]

class Record:
    # 类的构造函数，用来初始化对象
    def __init__(self, id, core_name, dataset, 
                 num_bulk, insert_frac, throughput, memory, 
                 num_model_nodes, num_data_nodes, max_level):
        self.id = id
        self.core_name = core_name
        self.dataset = dataset
        self.num_bulk = num_bulk
        self.insert_frac = insert_frac
        self.throughput = throughput
        self.memory = memory
        self.num_model_nodes = num_model_nodes
        self.num_data_nodes = num_data_nodes
        self.max_level = max_level

    def __str__(self):
        result = []
        for key, value in self.__dict__.items():
            result.append(f"{key}: {value}")
        return '\n'.join(result)

    
def Get_Record_from_File(filename, id, core_name):
    f = open(filename, "r")
    Lines = f.read().split(sep="\n")
    for line in Lines:
        for ds in DataSets:
            if ds in line:
                dataset = ds
        if "init_num_keys" in line:
            num_bulk = int(line.split()[-1])
        if "insert_frac" in line:
            insert_frac = float(line.split()[-1])
        if "throughput" in line:
            throughput = float(line.split()[-2])
        if "Total size" in line:
            memory = float((line.split()[-1])[:-2])
        if "num_model_nodes" in line:
            num_model_nodes = int(line.split()[-1])
        if "num_data_nodes" in line:
            num_data_nodes = int(line.split()[-1])
        if "Max level" in line:
            max_level = int(line.split()[-1])
    return Record(id, core_name, dataset, num_bulk, 
                  insert_frac, throughput, memory, 
                  num_model_nodes, num_data_nodes, max_level) 

file_path = "/home/nsh/ALEX/myexperiment/"
CoreNames = ["my", "alex"]
BulkNum = ["5e6", "1e7", "2e7"]
InsertFrac = ["00", "05", "25", "50", "75", "95", "100"]

Records = []
id = 0
for corename,dataset,bulknum,insfrac in itertools.product(CoreNames, DataSets, BulkNum, InsertFrac):
    id = id+1
    path = file_path+corename+"-"+dataset+"/"+"bulk"+bulknum+"_insfrac"+insfrac+".txt"
    Records.append(
        Get_Record_from_File(path, id, corename)
    )
    print(Records[-1],"\n")

