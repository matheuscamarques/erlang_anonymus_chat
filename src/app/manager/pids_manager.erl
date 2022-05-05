-module(pids_manager).
-export([
    verify_pid/1
    ]).

% verifica se o id do processo está funcionando
verify_pid(Pid) -> is_process_alive(Pid).