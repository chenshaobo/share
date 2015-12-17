%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 15:54
%%%-------------------------------------------------------------------
-module(default_post_handler).
-author("chenshb@mpreader.com").

-export([init/2]).
-export([allowed_methods/2,
    is_authorized/2,
    content_types_accepted/2]).

-export([from_json/2]).
-include("proto.hrl").

init(Req, HandlerOpt) ->
    {cowboy_rest, Req, HandlerOpt}.

is_authorized(Req, _State) ->
    {true, Req, _State}.

allowed_methods(Req, State) ->
    {[<<"POST">>], Req, State}.

%% process_content_type
content_types_accepted(Req, State) ->
    {[{{<<"application">>, <<"json">>, '*'}, from_json}],
        Req, State}.


from_json(Req, SubHandlers) ->
    PathBin = cowboy_req:path(Req),
    lager:info("path info:~p",[PathBin]),
    Ret =
        case lists:keyfind(utils:to_list(PathBin), 1, SubHandlers) of
            {_Path, SubHandler, false} ->
                do_handle(Req, SubHandler);
            {_Path, SubHandler, true} ->
                case do_auth(Req) of
                    true ->
                        do_handle(Req, SubHandler);
                    _ ->
                        "{\"ret\":303}"
                end;
            _ ->
                "{\"ret\":404}"
        end,
    Req1 = cowboy_req:set_resp_body(Ret, Req),
    lager:info("response ~p",[Ret]),
    {true, Req1, []}.

do_handle(Req, SubHandler) ->
    case do_parse_body(Req) of
        {true, Req1, ProtoTos} ->
            SubHandler:handle(Req1, ProtoTos);
        {error, _Req1, Ret} ->
            Ret
    end.

do_auth(_Req) ->
    true.

do_parse_body(Req) ->
    {ok, Body, Req1} = cowboy_req:body(Req),
    lager:info("BODY:~p",[Body]),
    case ?DECODE( Body) of
        ProtoTos when is_tuple(ProtoTos)->
            lager:info("proto:~p",[ProtoTos]),
            {true, Req1, ProtoTos};
        {error, _Reason} ->
            {error, Req1, "{\"ret\":404}"}
    end.