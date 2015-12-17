%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 11:32
%%%-------------------------------------------------------------------
-module(bus_login_handler).
-author("chenshb@mpreader.com").


%% API
-export([handle/2]).
-include("proto.hrl").
-include("db.hrl").

handle(_Req, #login_tos{account = Account, password = Password}) ->
    PasswordMD5 = utils:to_md5(Password),
    lager:info("~p",[PasswordMD5]),
        case eredis_pools:hget(?REDIS_POOL, ?ACCOUNT, Account) of
            undefined ->
                #login_toc{ret = 1002};
            UserID ->
                lager:info("user id :~p",[UserID]),
                case eredis_pools:hmget(?REDIS_POOL,UserID,["password","session"])of
                    [PasswordMD5,Session] ->
                        lager:info("~p",[Password]),
                        #login_toc{ret = 1003,user_id = UserID,session =Session };
                    _R ->
                        lager:info("~p",[_R]),
                        #login_toc{ret = 1002}
                end
        end.