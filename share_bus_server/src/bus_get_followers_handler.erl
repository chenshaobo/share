%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 21. 十二月 2015 10:05
%%%-------------------------------------------------------------------
-module(bus_get_followers_handler).
-author("chenshb@mpreader.com").


%% API
-export([handle/2]).
-include("proto.hrl").
-include("db.hrl").

handle(_Req, #get_data_tos{user_id = UserID,start = Start,end_index = End}) ->
    FollowersKey = utils:followers_key(UserID),
    Followers= eredis_pools:zrange(?REDIS_POOL,FollowersKey,Start,End),
    #get_data_toc{data =  [ utils:to_int(Follower) ||Follower <-Followers]}.