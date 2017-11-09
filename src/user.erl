%%% -----------------------------------------------------------	
%%% @author hongweigaokkx@163.com	
%%% @doc	
%%%     1. auto create, do not change	
%%%     2. config data's .erl file	
%%% @end	
	
-module(user).
-export([get/1]).	
-include("table_to_data_record.hrl").
get(1) ->
#data_user{	
user_id = 1,
name = "hello"
};	
get(2) ->
#data_user{	
user_id = 2,
name = "world"
};	
get(_) -> not_find.