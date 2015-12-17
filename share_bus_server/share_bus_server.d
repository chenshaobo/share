src/default_post_handler.erl:: src/proto.hrl; @touch $@
src/pool_worker_redis.erl:: src/pool_worker.erl; @touch $@
COMPILE_FIRST += pool_worker
src/share_cowboy.erl:: src/proto.hrl; @touch $@
