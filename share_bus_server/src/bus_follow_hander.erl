%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 21. 十二月 2015 9:09
%%%-------------------------------------------------------------------
-module(bus_follow_hander).
-author("chenshb@mpreader.com").


%% API
-export([handle/2]).
-include("proto.hrl").
-include("db.hrl").

handle(_Req,#follow_tos{user_id = UserID,follower_id = UserID})->
    #default_tos{ret = 1003};
handle(_Req, #follow_tos{user_id = UserID,follower_id = FollowID}) ->
    FollowingKey = utils:following_key(UserID),
    FollowersKey = utils:followers_key(FollowID),
    Now = utils:timestamp(),
    Commands = [?ZADD(FollowersKey,Now,UserID),?ZADD(FollowingKey,Now,FollowID)],

    R = eredis_pools:qp(?REDIS_POOL,Commands),
    lager:info("returen ~p",[R]),
    #default_tos{}.