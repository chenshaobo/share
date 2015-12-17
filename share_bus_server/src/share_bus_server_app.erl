-module(share_bus_server_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    ok = pools_start(),
    ok = share_cowboy:start(),
    share_bus_server_sup:start_link().

stop(_State) ->
    ok.


pools_start() ->
    PoolsConf = server_config:get_pools(),
    [begin
         WorkArgs = proplists:get_value(worker_args, PoolConf),
         PoolSize = proplists:get_value(size, PoolConf),
         WorkerMod = proplists:get_value(worker_module,PoolConf),
         PoolArgs = [{name, {local, PoolName}},
             {size, PoolSize},
             {worker_module, WorkerMod}
         ],
         poolboy:start_link(PoolArgs, WorkArgs)
     end || {PoolName, PoolConf} <- PoolsConf],
    ok.
