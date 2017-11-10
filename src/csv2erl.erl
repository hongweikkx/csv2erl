%%%-------------------------------------------------------------------
%%% @author gaohongwei
%%% Created : 02. 十一月 2017 19:23
%%%-------------------------------------------------------------------
-module(csv2erl).
-include("config.hrl").

%% API
-export([
    gen_erl/0,
    gen_hrl/0
]).

gen_hrl() ->
    erl_generate:generate_hrl_begin(),
    gen_hrl_record(?TABLES),
    erl_generate:generate_hrl_end().
gen_hrl_record([]) ->
    ok;
gen_hrl_record([H | Tail]) ->
    {FileBaseName, _, RecordName} = H,
    case check_csv(FileBaseName) of
        {ok, FileName} ->
            TupleList = erfc_4180:parse_file(FileName),
            erl_generate:generate_hrl_record(RecordName, TupleList);
        _ ->
            skip
    end,
    gen_hrl_record(Tail).

gen_erl() ->
    gen_erl(?TABLES).
gen_erl([]) ->
    ok;
gen_erl([H | Tail]) ->
    {FileBaseName, GenFile, RecordName} = H,
    case check_csv(FileBaseName) of
        {ok, FileName} ->
            TupleList = erfc_4180:parse_file(FileName),
            RecordInfo = get_record_info(lists:nth(1, TupleList)),
            Datas = lists:nthtail(?TYPE_LINE, TupleList),
            GenedFileName = gened_file_name(FileBaseName),
            %%  生成的文件名, 生成文件module, 生成的record名, 生成record的record_info, 生成的datas
            GenFile:gen(GenedFileName, FileBaseName, RecordName, RecordInfo, Datas);
        false ->
            skip
    end,
    gen_erl(Tail).


%% ====================== intel func ==============================
csv_name(FileBaseName) ->
    lists:concat([?CSV_FILE_DIR, FileBaseName, ".csv"]).
check_csv(FileBaseName) ->
    FileName = csv_name(FileBaseName),
    case filelib:is_file(FileName) of
        true ->
            {ok, FileName};
        false ->
            false
    end.

gened_file_name(FileBaseName) ->
    lists:concat([?ERL_FILE_DIR, FileBaseName, ".erl"]).

get_record_info(Tuple) ->
    Infos = tuple_to_list(Tuple),
    [list_to_atom(Info) || Info <- Infos].
