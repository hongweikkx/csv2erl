%%% -----------------------------------------------------------	
%%% @author hongweigaokkx@163.com	
%%% @doc	
%%%     1. auto create, do not change	
%%%     2. config data's .erl file	
%%% @end	
	
-module(hero).
-export([get/1]).	
-include("table_to_data_record.hrl").
get(1001) ->
#hero_user{	
hero_id = 1001,
hero_name = [232,178,130,232,157,137]
};	
get(1002) ->
#hero_user{	
hero_id = 1002,
hero_name = [231,148,132,229,167,172]
};	
get(_) -> not_find.