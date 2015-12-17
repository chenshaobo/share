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

handle(_Req, #post_get_tos{user_id = UserID,start = Start,end_index = End}) ->
    UserPostKey = utils:user_post_key(UserID),
    Posts= eredis_pools:lrange(?REDIS_POOL,UserPostKey,Start,End),
    lager:info("Posts:~p",[Posts]),
    Commands = [?HMGET(utils:post_id(PostID),["json"]) || PostID <-Posts],
    lager:info("commands:~p",[Commands]),
    PostJsons=eredis_pools:qp(?REDIS_POOL,Commands),
    lager:info("Post:~p",[eredis_pools:qp(?REDIS_POOL,Commands)]),
    #post_get_toc{posts = [ Json ||{ok,[Json]} <-PostJsons]}.