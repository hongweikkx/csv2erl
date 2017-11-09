%%%-------------------------------------------------------------------
%%% @author gaohongwei
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%      user.csv 生成 .erl 文件
%%% @end
%%% Created : 09. 十一月 2017 14:53
%%%-------------------------------------------------------------------
-module(data_user).
-include("table_to_data_record.hrl").

%% API
-export([
    gen/3
]).

gen(FileName, ModuleName, DataList) ->
    ExportStr = "-export([get/1]).",
    erl_generate:generate_erl_begin(FileName, ModuleName, ExportStr),
    gen_data_get(FileName, DataList),
    ok.


gen_data_get(FileName, []) ->
    LastStr = "get(_) -> not_find.",
    file:write_file(FileName, LastStr, [append]),
    ok;
gen_data_get(FileName, [Data | Tail]) ->
    RecordInfo = record_info(fields, data_user),
    RecordStr = erl_generate:generate_single_record(data_user, RecordInfo, Data),
    Id = element(1, Data),
    IdStr = io_lib:format("get(~p) ->~n", [Id]),
    Str = IdStr ++ RecordStr,
    file:write_file(FileName, Str, [append]),
    gen_data_get(FileName, Tail).

