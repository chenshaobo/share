%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 16:15
%%%-------------------------------------------------------------------
-module(default_get_handler).
-author("chenshb@mpreader.com").



-export([init/2]).
-export([allowed_methods/2,
    is_authorized/2
]).

-export([to_html/2]).
-include("proto.hrl").
-include("db.hrl").

init(Req, HandlerOpt) ->
    {cowboy_rest, Req, HandlerOpt}.

is_authorized(Req, _State) ->
    {true, Req, _State}.

allowed_methods(Req, State) ->
    {[<<"GET">>], Req, State}.

%% process_content_type
%% content_types_accepted(Req, State) ->
%%     {[{{'*', '*'}, get}],
%%         Req, State}.


to_html(Req, SubHandlers) ->
    PathBin = cowboy_req:path(Req),
    lager:info("path info:~p",[PathBin]),
    Ret = try
              case lists:keyfind(utils:to_list(PathBin), 1, SubHandlers) of
                  {_Path, SubHandler, NeedAuth} ->
                      do_handle(Req, SubHandler, NeedAuth);
                  _E ->
                      lager:info("get subhandler false:~p",[_E]),
                      #default_tos{ret = 1000}
              end
          catch ErrorType:Reason ->
              lager:error("do_business: ErrorType=~p, Reason=~p, Detail=~p", [ErrorType, Reason, erlang:get_stacktrace()]),
              #default_tos{ret = 1000}
          end,
    {?ENCODE(Ret), Req, []}.

do_handle(Req, SubHandler, true) ->
    case do_parse_body(Req) of
        {true, Req1, ProtoTos} ->
            UserID = erlang:element(2, ProtoTos),
            case do_auth(Req1, UserID) of
                true ->
                    SubHandler:handle(Req1, ProtoTos);
                false ->
                    #default_tos{ret = 1002}
            end;
        error ->
            #default_tos{ret = 1001}
    end.


do_auth(Req, UserID) ->
    Cookies = cowboy_req:parse_cookies(Req),
    case lists:keyfind(<<"uid">>, 1, Cookies) of
        {<<"uid">>, Session} ->
            case eredis_pools:hget(?REDIS_POOL, utils:user_key(UserID), <<"session">>) of
                Session ->
                    lager:info("session is :~p", [Session]),
                    true;
                _r ->
                    lager:info("_r :~p", [_r]),
                    false
            end;
        _ ->
            false
    end.

do_parse_body(Req) ->
    QS = cowboy_req:parse_qs(Req),
    Body = ?ENCODE(QS),
    lager:info("body:~p", [Body]),
    case ?DECODE(Body) of
        {error, _Reason, _} ->
            lager:error("~p", [_Reason]),
            error;
        ProtoTos when is_tuple(ProtoTos) ->
            lager:info("proto:~p", [ProtoTos]),
            {true, Req, ProtoTos}
    end.