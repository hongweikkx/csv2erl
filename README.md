# csv2erl
convert .csv file to .erl
### 编译
    ./rebar compile 
### 运行
    项目路径下执行  erl -pa ebin
### example run
    csv 文件放置在了./csv_file 下， 现在有两个 hero.csv 和 user_data.csv
   1. 通过调用 csv2erl:gen_hrl() 会生成 table_to_data_record.hrl 其中包含了
    全部csv文件的表结构体
    
   2. csv2erl:gen_erl() 会在./src/ 下生成 user_data.erl,hero.erl 文件, 其中包含了
    可以通过get/0 get_all来获取想要的数据
### define
     config.hrl 中放了配置的信息, 其中包含了 
        1. csv 文件的位置， 
        2. csv文件生成的hrl文件名
        3. csv文件生成的.erl 文件路径
     以上可以修改以满足自己的文件放置需求
        4. ?TABLES 定义了全部的生成信息  比如对于hero.csv 需要加入
        {hero, gen_data_hero, data_hero}, 
            4.1 其中heroo 为csv文件名，也是生成的文件名hero.erl
            4.2 gen_data_hero 为生成hero.erl 需要的gen文件名
            4.3 data_hero 为生成的reocrd名
### how to use
        1. 首先需要加入?TABLES 中相应的内容， 
        2. 并在./src/gen_data 中加入相应的生成代码, 
        3. ./rebar compil
        4. 调用csv2erl:gen_hrl() and gen_erl()
