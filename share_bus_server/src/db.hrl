%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 10:41
%%%-------------------------------------------------------------------
-author("chenshb@mpreader.com").

-define(REDIS_POOL,redis).
-define(ACCOUNT,account).
-define(USERS,users).
-define(NEXT_USER_ID,next_user_id).
-define(NEXT_POST_ID,next_post_id).

-type return_value() :: undefined | binary() | [binary() | nonempty_list()].

-define(ZINCRBY(Set,AddValue,Member), case AddValue of
                                          0 ->
                                              [];
                                          _->
                                              ["ZINCRBY",Set,AddValue,Member]
                                      end).

-define(INCRBY(Key,Value), case Value of
                               0 ->
                                   [];
                               _->
                                   ["INCRBY", Key, Value]
                           end).



-define(EXISTS(Key),["EXISTS",Key]).

-define(INCR(Key),["INCR",Key]).

-define(HMSET(Key,Values),["HMSET" |[Key | Values]]).

-define(HMGET(Key,Fields), ["HMGET" |[Key|Fields]]).

-define(HINCRBY(Key,Field,Value), ["HINCRBY" ,Key,Field,Value]).

-define(LPUSH(Key,Values), ["LPUSH" | [Key| Values]]).

-define(LRANGE(Key,Start,End),["LRANGE",Key,Start,End]).

-define(ZADD(OrderSet,Value ,Key), ["ZADD",OrderSet,Value,Key]).

-define(ZREM(OrderSet,Keys),["ZREM"|[OrderSet|Keys]]).


