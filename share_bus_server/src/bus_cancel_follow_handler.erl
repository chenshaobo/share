%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 21. 十二月 2015 9:34
%%%-------------------------------------------------------------------
-module(bus_cancel_follow_handler).
-author("chenshb@mpreader.com").


%% API
-export([handle/2]).
-include("proto.hrl").
-include("db.hrl").

handle(_Req, #cancel_follow_tos{user_id = UserID,cancel_follower = CancelFollower}) ->
    FollowingKey = utils:following_key(UserID),
    FollowersKey = utils:followers_key(CancelFollower),
    Commands = [?ZREM(FollowersKey,[UserID]),?ZREM(FollowingKey,[CancelFollower])],

    R = eredis_pools:qp(?REDIS_POOL,Commands),
    lager:info("returen ~p",[R]),
    #default_tos{}.
