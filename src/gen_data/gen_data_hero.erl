%%%-------------------------------------------------------------------
%%% @author gaohongwei
%%% @doc
%%%      user.csv 生成 .erl 文件
%%% @end
%%% Created : 09. 十一月 2017 14:53
%%%-------------------------------------------------------------------
-module(gen_data_hero).

%% API
-export([
    gen/5
]).

gen(FileName, ModuleName, RecordName, RecordInfo, DataList) ->
    ExportStr = "-export([get/1, get_all/0]).",
    erl_generate:generate_erl_begin(FileName, ModuleName, ExportStr),
    gen_data_get(FileName, RecordName, RecordInfo, DataList),
    gen_data_get_all(FileName, DataList),
    ok.


gen_data_get(FileName, _, _, []) ->
    LastStr = "get(_) -> not_find.\t\n\n",
    file:write_file(FileName, LastStr, [append]),
    ok;
gen_data_get(FileName, RecordName, RecordInfo, [Data | Tail]) ->
    RecordStr = erl_generate:generate_single_record(RecordName, RecordInfo, Data),
    Id = element(1, Data),
    IdStr = io_lib:format("get(~p) ->~n", [Id]),
    Str = IdStr ++ RecordStr,
    file:write_file(FileName, Str, [append]),
    gen_data_get(FileName, RecordName, RecordInfo, Tail).


gen_data_get_all(FileName, DataList) ->
    KeyList = [element(1, Data) || Data <- DataList],
    Str = io_lib:format("get_all() -> ~n    ~p.~n", [KeyList]),
    file:write_file(FileName, Str, [append]).
