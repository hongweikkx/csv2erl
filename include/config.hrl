%%%-------------------------------------------------------------------
%%% @author hongweigaokkx@163.com
%%%-------------------------------------------------------------------
-ifndef(CONFIG).
-define(CONFIG, true).

-define(CSV_FILE_DIR,  "./csv_file/").                       %% csv 文件位置
-define(HRL_DIR_NAME, "./include/table_to_data_record.hrl").   %% csv 文件生成的hrl文件
-define(ERL_FILE_DIR,  "./src/").          %% csv 文件生成的.erl 文件路径

-define(TYPE_LINE,            3).    %% 类型行

-define(TABLES,
    [                    %% {csv 文件名, 生成文件, 生成record名
        {user, data_user, data_user},
        {hero, data_hero, hero_user}
    ]
).

-endif.
