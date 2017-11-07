%%%-------------------------------------------------------------------
%%% @author gaohongwei
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 十一月 2017 19:23
%%%-------------------------------------------------------------------
-module(csv2erl).

%% API
-export([start/2, start/1]).
-define(CSV_FILE_DIR,  "./csv_file/").
-define(ERL_FILE_DIR,  "./").

start(Opts) ->
    Tables = get_files(),
    start(Tables, Opts).
start([], _Opts) ->
    ok;
start([FileName | Tail], Opts) ->
    case is_csv(FileName) of
        true ->
            TupleList = erfc_4180:parse_file(?CSV_FILE_DIR ++ FileName, Opts),
            erl_generate:generate_hrl([TupleList]);
        false ->
            skip
    end,
    start(Tail, Opts).


get_files() ->
    case file:list_dir(?CSV_FILE_DIR) of
        {ok, FileNames} ->
            FileNames;
        {error, Reason} ->
            throw(Reason)
    end.

is_csv(FileName) ->
    ".csv" == filename:extension(FileName).

%%csv_2_erl_file_name(CsvName) ->
%%    BaseName = filename:basename(CsvName, ".csv"),
%%    lists:concat([?ERL_FILE_DIR, BaseName, ".erl"]).


