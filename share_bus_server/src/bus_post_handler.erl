%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 14:20
%%%-------------------------------------------------------------------
-module(bus_post_handler).
-author("chenshb@mpreader.com").


%% API
-export([handle/2]).
-include("proto.hrl").
-include("db.hrl").

handle(_Req, #post_tos{user_id = UserID, text = Text, pics = Pics}) ->
    UserPostKey = utils:user_post_key(UserID),
    TimeStamp = utils:timestamp(),
    PostID = eredis_pools:incr(?REDIS_POOL, ?NEXT_POST_ID),
    PostKey = utils:post_key(PostID),
    _SubKey = utils:sub_key(UserID),

    Json = jsonx:encode({struct, [{user_id, UserID}, {timestamp, TimeStamp}, {post_id, PostID}, {text, Text}, {pics, Pics}]}),
    Commands = [
        ?HMSET(PostKey, ["post_id", PostID, "user_id", UserID, "timestamp", TimeStamp, "json", Json]),
        ?LPUSH(UserPostKey, [PostID])
    ],
    R = eredis_pools:qp(?REDIS_POOL, Commands),
    lager:info("~p", [R]),
    #post_toc{post_id = utils:to_int(PostID)}.

