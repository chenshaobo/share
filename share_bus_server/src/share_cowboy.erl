%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 14:57
%%%-------------------------------------------------------------------
-module(share_cowboy).
-author("chenshb@mpreader.com").


%% API
-export([start/0]).
-export([restart/0]).
-export([stop/0]).




start() ->
    RouterList = myrouterlist(),
    Dispatch = cowboy_router:compile(RouterList),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8080}], [
        {env, [{dispatch, Dispatch}]}
    ]),

    ok.

stop() ->
    ok = cowboy:stop_listener(http),
    ok.

restart() ->
    cowboy:set_env(http, dispatch, cowboy_router:compile(myrouterlist())),
    ok.

myrouterlist() ->
    [
        {'_',[
            {"/p/[...]" , default_post_handler,[
                {"/p/register",bus_register_handler,false},
                {"/p/login",   bus_login_handler,false},
                {"/p/post",    bus_post_handler,true},
                {"/p/follow",  bus_follow_hander,true},
                {"/p/cancle/follow", bus_cancel_follow_handler,true}
            ]},

            {"/g/[...]", default_get_handler,[
                {"/g/posts", bus_get_post_handler,true},
                {"/g/followers",bus_get_followers_handler,true},%%获取粉丝
                {"/g/following",bus_get_following_handler,true} %%获取关注的
            ]}
        ]}
    ].