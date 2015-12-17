%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 17:20
%%%-------------------------------------------------------------------
-author("chenshb@mpreader.com").

-record(register_tos,{ account::binary(),password::binary()}).
-record(register_toc,{ ret::any(),user_id::integer(),session::binary()}).

-record(login_tos,{ account::binary(), password::binary(),terminal::binary()}).
-record(login_toc,{ ret::any(),user_id::integer(),session::binary()}).





-define(DECODE(Body),begin F = jsonx:decoder(?TOS_LIST),
                     F(Body)
                        end).

-define(ENCODE(Record),begin F = jsonx:encoder(?TOC_LIST),
                        F(Record)
                        end).


-define(TOS_LIST,[
    {register_tos,record_info(fields,register_tos)},
    {login_tos,record_info(fields,login_tos)}
]).

-define(TOC_LIST,[
    {register_toc,record_info(fields,register_toc)},
    {login_toc,record_info(fields,login_toc)}
]).