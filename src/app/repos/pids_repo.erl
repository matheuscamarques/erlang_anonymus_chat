-module(pids_repo).
-export([
         start/0,
         insert/1,
         delete/1,
         get_all/0
        ]).

start() -> 
    ets:new(pids, [public,named_table]).

% messages_repo:insert({<< "Hello" >>})
insert(Pid) -> 
   true = ets:insert(pids, {Pid}),
   Pid.

delete(Pid) -> 
    ets:delete(pids, Pid).

get_all() ->
    ets:tab2list(pids).
