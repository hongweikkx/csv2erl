%%%-------------------------------------------------------------------
%%% @author gaohongwei
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%    erl 生成
%%% @end
%%% Created : 03. 十一月 2017 19:33
%%%-------------------------------------------------------------------
-module(erl_generate).
%% API
-define(DATA_TO_RECORD_HRL, "DATA_TO_RECORD_HRL").
-define(HRL_DIR_NAME, "./include/table_to_data_record.hrl").

-export([generate/2,
    generate_hrl/1
]).

generate(_FileName, _TupleList) ->
    ok.

%% ============ generate .hrl file ===========================
generate_hrl(RecordTuples) ->
    io:format("########RecordTuples:~p~n", [RecordTuples]),
    generate_hrl_begin(),
    generate_hrl_record(RecordTuples),
    generate_hrl_end().

generate_hrl_begin() ->
    file:write_file(?HRL_DIR_NAME, "%%% -----------------------------------------------------------\t\n"),
    file:write_file(?HRL_DIR_NAME, "%%% @author hongweigaokkx@163.com\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "%%% @doc\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "%%%     1. auto create, do not change\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "%%%     2. config data's record hrl\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "%%% @end\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "-ifndef(TABLE_TO_DATA_RECORD).\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "-define(TABLE_TO_DATA_RECORD, true).\t\n", [append]).

generate_hrl_record([]) ->
    ok;
generate_hrl_record([Record | Tail]) ->
    [IdTuple, Descs| _Datas] = Record,
    RecordName = get_record_name(),
    RecordBegin = lists:concat(["-record(", RecordName,",{\t\n"]),
    RecordIds = generate_hrl_record_util(IdTuple, Descs),
    RecordEnd = "}).\t\n",
    RecordStr = lists:concat([RecordBegin, RecordIds, RecordEnd]),
    file:write_file(?HRL_DIR_NAME, RecordStr, [append]),
    generate_hrl_record(Tail).


%% todo 间隔问题
generate_hrl_record_util(IdTuple, Descs) ->
    IdList = tuple_to_list(IdTuple),
    DescList = tuple_to_list(Descs),
    generate_hrl_record_util(IdList, DescList, "").
generate_hrl_record_util([], _, AccStr) ->
    AccStr;
generate_hrl_record_util([Id | Tail], DescList, AccStr) ->
    {Desc, DescTail} =
        case DescList of
            [] ->
                {"", []};
            [H | _T] ->
                {H, _T}
        end,
    case Tail =:= [] of   %% 是否是最后一个字段
        true ->
            NAccStr = lists:concat([AccStr, string:to_lower(Id), "     %%", Desc,"\t\n"]);
        false ->
            NAccStr = lists:concat([AccStr, string:to_lower(Id), ",    %%", Desc,"\t\n"])
    end,
    generate_hrl_record_util(Tail, DescTail, NAccStr).

generate_hrl_end() ->
    file:write_file(?HRL_DIR_NAME, "-endif.", [append]).

%% ================ generate .erl file ===========================



%% ================ intel func ================
get_record_name() ->
    "hero_record".
