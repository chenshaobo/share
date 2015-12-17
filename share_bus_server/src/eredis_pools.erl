%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 14:36
%%%-------------------------------------------------------------------
-module(eredis_pools).
-author("chenshb@mpreader.com").

-include("db.hrl").
%% API
-export([
    q/2,
    qp/2,
    q_noreply/2
]).
-export([get/2]).
-export([set/3]).
-export([set/4]).
-export([zscore/3]).
-export([zadd/4]).
-export([zincr/4]).
-export([zrange/4]).
-export([zrevrange/4]).
-export([exists/2]).
-export([incr/2]).
-export([incr/3]).
-export([zrevrank/3]).
-export([hget/3]).
-export([hmset/3]).
-export([hmget/3]).
-export([hincrby/3]).
-export([hincrby/4]).
-export([lrange/4]).

hincrby(Pool,Key,Field)->
    hincrby(Pool,Key,Field,1).

hincrby(Pool,Key,Field,Value)->
    {ok,R} = q(Pool, ?HINCRBY(Key,Field,Value)),
    R.

lrange(Pool,UserPostKey,Start,End)->
    {ok,R} = q(Pool, ?LRANGE(UserPostKey,Start,End)),
    R.

hmset(Pool,Key,FieldsValues)->
    {ok,R} = q(Pool, ?HMSET(Key,FieldsValues)),
    R.

hmget(Pool,Key,Fields)->
    {ok,R} = q(Pool, ?HMGET(Key,Fields)),
    R.

exists(Pool,Key) ->
    {ok,R} = q(Pool,["EXISTS",Key]),
    R.

get(Pool, Key) ->
    {ok, Values} = q(Pool, ["GET", Key]),
    Values.

hget(Pool,Key,Field)->
    {ok,Value} = q(Pool,["HGET",Key,Field]),
    Value.

incr(Pool,Key)->
    {ok, R} = q(Pool, ["INCR", Key]),
    R.
incr(Pool,Key,Value)->
    {ok, R} = q(Pool, ["INCRBY", Key, Value]),
    R.

set(Pool, Key, Value) ->
    {ok, <<"OK">>} = q(Pool, ["SET", Key, Value]).

set(Pool,Key,Value,Expire)->
    {ok,<<"OK">>} = q(Pool,["SET",Key,Value,"EX", Expire]).

zscore(Pool,Set,Member)->
    {ok,Value} = q(Pool,["ZSCORE",Set,Member]),
    Value.

zincr(_Pid,_Set,_Member,0)->
    ignore;
zincr(Pool,Set,Member,AddValue)->
    {ok,R}=q(Pool,["ZINCRBY",Set,(AddValue),Member]),
    R.


zadd(Pool,Set,Member,Score)->
    {ok,_}  = q(Pool,["ZADD",Set,Score,Member]).


zrange(Pool,Set,Start,End)->
    {ok,Data} = q(Pool,["ZRANGE",Set,Start,End]),
    Data.

zrevrange(Pool,Set,Start,End)->
    {ok,Data} = q(Pool,["ZREVRANGE",Set,Start,End,"withscores"]),
    Data.

zrevrank(Pool,Set,Member)->
    {ok,Rank} = q(Pool,["ZREVRANK" ,Set,Member]),
    Rank.



-spec q(Pool::atom()|pid(), Commands::[any()]) -> {ok, return_value()} | {error, Reason::binary() | no_connection}.
q(Pool,Commands)->
    poolboy:transaction(Pool,fun(Worker)-> eredis:q(Worker,Commands) end).

-spec qp(Pool::atom()|pid(), Commands::[any()]) -> {ok, return_value()} | {error, Reason::binary() | no_connection}.
qp(Pool,Commands)->
    poolboy:transaction(Pool,fun(Worker)-> eredis:qp(Worker,Commands) end).


-spec q_noreply(Client::atom()|pid(), Command::[any()]) -> ok.
q_noreply(Pool,Commands)->
    poolboy:transaction(Pool,fun(Worker)-> eredis:q_noreply(Worker,Commands) end).