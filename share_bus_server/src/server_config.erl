-module(server_config).
-export([
	get_pools/0,	 find_by_key/1
]).

find_by_key(Key)->
	case Key of
	pools -> [{redis,[{size,10},{worker_module,eredis_client},{worker_args,[{ip,[49,55,50,46,49,54,46,55,46,49,49,57]},{port,6379},{db,0},{password,[]}]}]}];
	_-> undefined
 end.
get_pools() -> find_by_key(pools).

