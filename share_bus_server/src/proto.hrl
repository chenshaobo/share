%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 17:20
%%%-------------------------------------------------------------------
-author("chenshb@mpreader.com").

-record(register_tos, {account :: binary(), password :: binary()}).
-record(register_toc, {ret = 0 :: integer(), user_id :: integer(), session :: binary()}).

-record(login_tos, {account :: binary(), password :: binary(), terminal :: binary()}).
-record(login_toc, {ret = 0 :: integer(), user_id :: integer(), session :: binary()}).


-record(post_tos, {user_id :: integer(), text :: binary(), pics :: [binary()]}).
-record(post_toc, {ret = 0 :: integer(), post_id :: integer()}).


-record(follow_tos, {user_id :: integer(), follower_id :: integer()}).
-record(cancel_follow_tos, {user_id :: integer(), cancel_follower :: integer()}).

-record(get_data_tos, {user_id :: integer(), start :: integer(), end_index :: integer()}).
-record(get_data_toc, {ret = 0 :: integer(), data = [] :: list()}).
-record(default_tos, {ret = 0 :: integer()}).

-define(DECODE(Body), begin
                          F = jsonx:decoder(?PROTOS),
                          F(Body)
                      end).

-define(ENCODE(Record), begin
                            F1 = jsonx:encoder(?PROTOS),
                            F1(Record)
                        end).


-define(PROTOS, [
    {default_tos, record_info(fields, default_tos)},
    {register_tos, record_info(fields, register_tos)},
    {login_tos, record_info(fields, login_tos)},
    {post_tos, record_info(fields, post_tos)},
    {post_toc, record_info(fields, post_toc)},
    {register_toc, record_info(fields, register_toc)},
    {login_toc, record_info(fields, login_toc)},
    {get_data_tos, record_info(fields, get_data_tos)},
    {get_data_toc, record_info(fields, get_data_toc)},
    {follow_tos, record_info(fields, follow_tos)},
    {cancel_follow_tos, record_info(fields, cancel_follow_tos)}
%%     {get_followers_tos, record_info(fields, get_followers_tos)},
%%     {get_followers_toc, record_info(fields, get_followers_toc)},
%%     {get_following_tos, record_info(fields, get_following_tos)},
%%     {get_following_toc, record_info(fields, get_following_tos)}
]).
