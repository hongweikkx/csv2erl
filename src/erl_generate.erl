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
-include("config.hrl").

-export([
    generate_hrl_begin/0,
    generate_hrl_record/2,
    generate_hrl_end/0

]).
-export([
    generate_erl_begin/3,
    generate_single_record/3
]).

%% ============ generate .hrl file ===========================
generate_hrl_begin() ->
    file:write_file(?HRL_DIR_NAME, "%%% -----------------------------------------------------------\t\n"),
    file:write_file(?HRL_DIR_NAME, "%%% @author hongweigaokkx@163.com\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "%%% @doc\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "%%%     1. auto create, do not change\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "%%%     2. config data's record hrl\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "%%% @end\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "-ifndef(TABLE_TO_DATA_RECORD).\t\n", [append]),
    file:write_file(?HRL_DIR_NAME, "-define(TABLE_TO_DATA_RECORD, true).\t\n", [append]).

generate_hrl_record(RecordName, Record) ->
    [IdTuple, Descs | _] = Record,
    RecordBegin = lists:concat(["-record(", RecordName,",{\t\n"]),
    RecordIds = generate_hrl_record_util(IdTuple, Descs),
    RecordEnd = "}).\t\n",
    RecordStr = lists:concat([RecordBegin, RecordIds, RecordEnd]),
    file:write_file(?HRL_DIR_NAME, RecordStr, [append]).


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
            NAccStr = lists:concat([AccStr, "    ", string:to_lower(Id), "     %%", Desc,"\t\n"]);
        false ->
            NAccStr = lists:concat([AccStr, "    ", string:to_lower(Id), ",    %%", Desc,"\t\n"])
    end,
    generate_hrl_record_util(Tail, DescTail, NAccStr).


generate_hrl_end() ->
    file:write_file(?HRL_DIR_NAME, "-endif.", [append]).
%% ================ generate .erl file ===========================
%% ModuelName: hero , ExportStr: "-export([get/1, get_all/0])."
generate_erl_begin(FileName, ModuleName, ExportStr) ->
    file:write_file(FileName, "%%% -----------------------------------------------------------\t\n"),
    file:write_file(FileName, "%%% @author hongweigaokkx@163.com\t\n", [append]),
    file:write_file(FileName, "%%% @doc\t\n", [append]),
    file:write_file(FileName, "%%%     1. auto create, do not change\t\n", [append]),
    file:write_file(FileName, "%%%     2. config data's .erl file\t\n", [append]),
    file:write_file(FileName, "%%% @end\t\n", [append]),
    %% Module
    ModuleStr = generate_module_str(ModuleName),
    file:write_file(FileName, ModuleStr, [append]),
    %% Export
    file:write_file(FileName, ExportStr, [append]),
    %% include
    HRlName = filename:basename(?HRL_DIR_NAME),
    IncludeStr = generate_include_str(HRlName),
    file:write_file(FileName, IncludeStr, [append]).

generate_module_str(ModuleName) ->
    io_lib:format("\t\n-module(~p).~n", [ModuleName]).

generate_include_str(HrlName) ->
    io_lib:format("\t\n-include(~p).~n", [HrlName]).

generate_single_record(RecordName, RecordInfo, DataTuple) ->
    DataList = tuple_to_list(DataTuple),
    Begin = io_lib:format("    #~p{\t\n", [RecordName]),
    F = fun(EAtom, {AccStr, AccDataList}) ->
        [Data | TailData] = AccDataList,
        DataStr =
        case TailData =:= [] of
            true ->
                io_lib:format("        ~p = ~p~n", [EAtom, Data]);
            false ->
                io_lib:format("        ~p = ~p,~n", [EAtom, Data])
        end,
        NAccStr = lists:concat([AccStr, DataStr]),
        {NAccStr, TailData}
        end,
    {Content, _} = lists:foldl(F, {"", DataList}, RecordInfo),
    End = "};\t\n",
    Begin ++ Content ++ End.

