%%%-------------------------------------------------------------------
%%% @author chenshb@mpreader.com
%%% @copyright (C) 2015, <MPR Reader>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十二月 2015 10:48
%%%-------------------------------------------------------------------
-module(pool_worker).
-author("chenshb@mpreader.com").
-behaviour(gen_server).
-behaviour(poolboy_worker).
%% API
-export([start_link/1]).
%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([]).

-define(SERVER, ?MODULE).

-callback init_worker(WorkerArgs::proplists:proplist()) -> {ok, any()} | {error, any()} .
-callback work(Args::proplists:proplist(), State::any()) -> {ok, any()} | {error, any()}.
-callback sync_work(Args::proplists:proplist(), From::pid(), State::any()) -> {ok, any(), any()} | {error, any()}.

-record(state, {mod :: atom(), worker_state :: any()}).


%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link(WorkerArgs::proplists:proplist()) ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link(WorkerArgs) ->

    gen_server:start_link(?MODULE, WorkerArgs, []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
    {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term()} | ignore).
init(WorkerArgs) ->
    lager:info("~p",[WorkerArgs]),
    Mod = proplists:get_value(mod, WorkerArgs),
    {ok, ModState} = Mod:init_worker(WorkerArgs),
    {ok, #state{mod = Mod, worker_state = ModState}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
    {reply, Reply :: term(), NewState :: #state{}} |
    {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
    {stop, Reason :: term(), NewState :: #state{}}).
handle_call(Request, From, State = #state{mod = Mod,worker_state = WorkState}) ->
    {Reply1, NewState1} =
        case Mod:sync_work(Request, From, WorkState) of
            {ok, Reply, NewState} ->
                {Reply, NewState};
            {error, Reason} ->
                lager:info("sync work error :~p", [Reason]),
                {Reason, State}
        end,
    {reply, Reply1, State#state{worker_state = NewState1}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #state{}}).
handle_cast(Request, State=#state{mod = Mod,worker_state = WorkState}) ->
    {ok,NewWorkState}=Mod:work(Request,WorkState),
    {noreply, State#state{worker_state = NewWorkState}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #state{}}).
handle_info(Request, State=#state{mod = Mod,worker_state = WorkState}) ->
    {ok,NewWorkState}=Mod:work(Request,WorkState),
    {noreply, State#state{worker_state = NewWorkState}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
    {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
