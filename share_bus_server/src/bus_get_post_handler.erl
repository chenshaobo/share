%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 16:46
%%%-------------------------------------------------------------------
-module(bus_get_post_handler).
-author("chenshb@mpreader.com").


%% API
-export([handle/2]).
-include("proto.hrl").
-include("db.hrl").

handle(_Req, #get_data_tos{user_id = UserID,start = Start,end_index = End}) ->
    UserPostKey = utils:user_post_key(UserID),
    Posts= eredis_pools:lrange(?REDIS_POOL,UserPostKey,Start,End),
    Commands = [?HMGET(utils:post_key(PostID),["json"]) || PostID <-Posts],
    PostJsons=eredis_pools:qp(?REDIS_POOL,Commands),
    #get_data_toc{data =  [ Json ||{ok,[Json]} <-PostJsons]}.