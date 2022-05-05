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
    manage_pids(A,Message),
    loop().

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