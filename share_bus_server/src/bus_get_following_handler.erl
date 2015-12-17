%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 21. 十二月 2015 10:20
%%%-------------------------------------------------------------------
-module(bus_get_following_handler).
-author("chenshb@mpreader.com").


%% API
-export([handle/2]).
-include("proto.hrl").
-include("db.hrl").

handle(_Req, #get_data_tos{user_id = UserID,start = Start,end_index = End}) ->
    FollowingKey = utils:following_key(UserID),
    Followings= eredis_pools:zrange(?REDIS_POOL,FollowingKey,Start,End),
    lager:info("key:~p,data:~p",[FollowingKey,Followings]),
    #get_data_toc{data =  [ utils:to_int(Following) ||Following <-Followings]}.