-module(pids_manager).
-export([
    verify_pid/1,
    manage_pids/2
]).

% verifica se o id do processo está funcionando
verify_pid(Pid) -> is_process_alive(Pid).


manage_pids([],_) -> true;
manage_pids([A | B],Message) -> 
    {Pid} = A,
    Exist = pids_manager:verify_pid(Pid),
    manage_pid(Pid,Exist,Message),
    manage_pids(B,Message).

manage_pid(Pid,true,Message) -> 
    % io:format("Sending message to pid ~p~n",[Pid]),
    % io:format("Message: ~p~n",[Message]),
    erlang:send_after(200, Pid,Message),
    true;
manage_pid(Pid,false,_) -> pids_repo:delete(Pid).   