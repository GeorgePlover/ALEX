
import itertools
import matplotlib.pyplot as plt

DataSets = ["lognormal-190M","longitudes-200M","longlat-200M","ycsb-200M", "binom-200M"]

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

def Filter(Records: list , core_name: str ,dataset: str, bulknum: int, insfrac: float):
    ret=[]
    for record in Records:
        #print(record.insert_frac,insfrac,record.insert_frac == insfrac)
        if(record.core_name == core_name
           and record.dataset == dataset
           and record.num_bulk == bulknum
           and abs(record.insert_frac - insfrac)<1e-9):
            ret.append(record)
    return ret

# 画图，根据数据集，对不同的插入比例
def Draw(Records: list , dataset: str, bulknum: int, insfrac: list, outfile = "chart.png"):
    alex = []
    my = []
    for record in Records:
        if record.dataset == dataset and record.num_bulk == bulknum:
            if record.core_name == "alex":
                alex.append(record.throughput)
            else:
                my.append(record.throughput)
    
    x = range(len(insfrac))
    ins_row = insfrac.copy()
    for it in range(len(ins_row)):
        ins_row[it]=str(int(ins_row[it]))+"%"

    # 绘制条形图
    #plt.clf()
    plt.bar(x, alex, width=0.4, label='alex')
    plt.bar([i + 0.4 for i in x], my, width=0.4, label='mycore')

    # 设置 x 轴刻度
    plt.xticks([i + 0.2 for i in x], ins_row)


    # 添加图例
    plt.legend()
    plt.ylabel("Throughput (op/sec)", labelpad=-40, y=1.06, rotation=0)
    plt.xlabel("Percentage of Insert", x=0.80)
    plt.title(dataset[:-5],fontsize=30)

    # 显示图形
    #plt.savefig(outfile)
    

file_path = "/home/nsh/ALEX/myexperiment/"
CoreNames = ["my", "alex"]
BulkNum = ["5e6", "1e7", "2e7", "100000000"]
InsertFrac = ["00", "05", "25", "50", "75", "95", "100"]

Records = []
id = 0
for corename,dataset,bulknum,insfrac in itertools.product(CoreNames, DataSets, BulkNum, InsertFrac):
    id = id+1
    path = file_path+corename+"-"+dataset+"/"+"bulk"+bulknum+"_insfrac"+insfrac+".txt"
    Records.append(
        Get_Record_from_File(path, id, corename)
    )
    # print(Records[-1],"\n")

plt.figure(figsize=(30,14),dpi=100)
plt.rcParams['font.size'] = 22
show_length = len(DataSets)
id=0
for dataset in DataSets:
    for num in BulkNum:
        bnum = int(float(num))
        if(bnum == 20000000):
            id=id+1
            plt.subplot(2,3,id)
            Draw(Records,dataset,bnum,InsertFrac,dataset+"&"+str(bnum)+"chart.png")

plt.tight_layout() # 自动调整子图间距，解决重叠问题
plt.savefig("chart.png")

# 单项对比
for dataset,bulknum,insfrac in itertools.product(DataSets, BulkNum, InsertFrac):
    if(bulknum != "1e7" or insfrac != "95"):
        continue
    x = Filter(Records,"my",dataset,int(float(bulknum)),float(insfrac)*0.01)[0].throughput
    y = Filter(Records,"alex",dataset,int(float(bulknum)),float(insfrac)*0.01)[0].throughput
    print(dataset,bulknum,insfrac,(x/y-1.0)*100,"%")