%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 17:12
%%%-------------------------------------------------------------------
-module(bus_register_handler).
-author("chenshb@mpreader.com").

%% API
-export([handle/2]).
-include("proto.hrl").
-include("db.hrl").

handle(_Req,Proto)->
    #register_tos{account = Account,password = Password} = Proto,
    case eredis_pools:hget(?REDIS_POOL,?ACCOUNT,Account)of
        undefined ->
            UserID = eredis_pools:incr(?REDIS_POOL,?NEXT_USER_ID),
            UserKey = utils:user_key(UserID),
            Session =utils:gen_session(),
            Commands = [?HMSET(UserKey,["account",Account,"password",utils:to_md5(Password),"session",Session]),
                        ?HMSET(?ACCOUNT,[Account,UserKey])
                       ],
            R=eredis_pools:qp(?REDIS_POOL,Commands),
            lager:info("r=~p",[R]),
            #register_toc{ret=1000,user_id=utils:to_int(UserID),session= Session};
        _ ->
            #register_toc{ret=1004}
    end.
