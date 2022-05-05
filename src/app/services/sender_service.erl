-module(sender_service).
-export([
    start/0,
    loop/0
]).

start() -> 
    spawn(sender_service, loop, []).

loop() ->
    A = pids_repo:get_all(),
    Message = messages_repo:get_last(),
    pids_manager:manage_pids(A,Message),
    loop().

