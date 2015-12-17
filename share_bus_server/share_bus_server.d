src/bus_login_handler.erl:: src/db.hrl src/proto.hrl; @touch $@
src/bus_post_handler.erl:: src/db.hrl src/proto.hrl; @touch $@
src/bus_register_handler.erl:: src/db.hrl src/proto.hrl; @touch $@
src/default_post_handler.erl:: src/db.hrl src/proto.hrl; @touch $@
src/eredis_pools.erl:: src/db.hrl; @touch $@
src/pool_worker_redis.erl:: src/pool_worker.erl; @touch $@
COMPILE_FIRST += pool_worker
