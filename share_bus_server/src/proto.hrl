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
-record(register_toc,{ ret =0 ::integer(),user_id::integer(),session::binary()}).

-record(login_tos,{ account::binary(), password::binary(),terminal::binary()}).
-record(login_toc,{ret =0 ::integer(),user_id::integer(),session::binary()}).


-record(post_tos,{user_id::integer(), text::binary(),pics::[binary()]}).
-record(post_toc,{ret = 0 ::integer(),post_id::integer()}).

-record(post_get_tos,{user_id::integer(),start::integer(), end_index::integer()}).
-record(post_get_toc,{ret=0::integer(),posts=[]::list()}).


-record(default_ret,{ret=0::integer()}).

-define(DECODE(Body),begin F = jsonx:decoder(?PROTOS),
                     F(Body)
                        end).

-define(ENCODE(Record),begin F1 = jsonx:encoder(?PROTOS),
                        F1(Record)
                        end).


-define(PROTOS,[
    {register_tos,record_info(fields,register_tos)},
    {login_tos,record_info(fields,login_tos)},
    {post_tos,record_info(fields,post_tos)},
    {post_toc,record_info(fields,post_toc)},
    {register_toc,record_info(fields,register_toc)},
    {login_toc,record_info(fields,login_toc)},
    {post_get_tos,record_info(fields,post_get_tos)},
    {post_get_toc,record_info(fields,post_get_toc)}
]).
