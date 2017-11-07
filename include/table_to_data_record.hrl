%%% -----------------------------------------------------------	
%%% @author hongweigaokkx@163.com	
%%% @doc	
%%%     1. auto create, do not change	
%%%     2. config data's record hrl	
%%% @end	
-ifndef(TABLE_TO_DATA_RECORD).	
-define(TABLE_TO_DATA_RECORD, true).	
-record(hero_record,{	
heroid,    %%英雄id	
name,    %%名字	
type,    %%类型	
type_id,    %%类型id	
easy     %%难易程度	
}).	
-endif.