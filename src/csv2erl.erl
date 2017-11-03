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
            io:format("####TupleList:~p~n", [TupleList]),
            write_2_erl(FileName, TupleList);
        false ->
            skip
    end,
    start(Tail, Opts).

write_2_erl(CsvName, TupleList) ->
    ErlName = csv_2_erl_file_name(CsvName),
    io:format("#########ErlName:~p~n", [ErlName]),
    {ok, Fd} = file:open(ErlName, [write]),
    Str = term_to_binary(TupleList),
    io:format(Fd, Str, []),
    file:close(Fd).

get_files() ->
    case file:list_dir(?CSV_FILE_DIR) of
        {ok, FileNames} ->
            FileNames;
        {error, Reason} ->
            throw(Reason)
    end.

is_csv(FileName) ->
    WordList = string:tokens(FileName, "."),
    "csv" == lists:last(WordList).

csv_2_erl_file_name(CsvName) ->
    WordList = string:tokens(CsvName, "."),
    NWordList = lists:droplast(WordList),
    ?ERL_FILE_DIR ++ lists:concat(NWordList) ++ ".erl".

