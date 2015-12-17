%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 11:02
%%%-------------------------------------------------------------------
-module(pool_worker_redis).
-author("chenshb@mpreader.com").

-behaviour(pool_worker).
%% API
-export([init_worker/1]).
-export([work/2]).
-export([sync_work/3]).

init_worker(WorkArgs)->
    IP =proplists:get_value(ip,WorkArgs),
    Port = proplists:get_value(port,WorkArgs),
    eredis:start_link(IP,Port).




work(Request,State)->
    lager:info("~p",[Request]),
    {ok,State}.

sync_work(Request,From,State)->
    lager:info("~p from ~p",[Request,From]),
    {ok,"unknow",State}.