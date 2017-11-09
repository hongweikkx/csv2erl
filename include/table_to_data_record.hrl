%%% -----------------------------------------------------------	
%%% @author hongweigaokkx@163.com	
%%% @doc	
%%%     1. auto create, do not change	
%%%     2. config data's record hrl	
%%% @end	
-ifndef(TABLE_TO_DATA_RECORD).	
-define(TABLE_TO_DATA_RECORD, true).	
-record(data_user,{	
user_id,    %%玩家id	
name     %%玩家名字	
}).	
-record(hero_user,{	
hero_id,    %%英雄id	
hero_name     %%英雄名字	
}).	
-endif.