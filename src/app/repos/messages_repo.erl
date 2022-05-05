-module(messages_repo).
-export([
    start/0,
    insert/1,
    get_last/0,
    delete/1
]).

start() -> 
    ets:new(messages, [public,named_table]).

% messages_repo:insert({<< "Hello" >>})
insert({Message}) -> 
   Time = now(),
   Id = list_to_binary(uuid:uuid_to_string(uuid:get_v4())),  
   true = ets:insert(messages, {Id, Message}),
   Id.

% messages_repo:getLast()
get_last() -> 
    Id = ets:last(messages),
    Return = getById(Id),
    delete(Id),
    Return.

delete(Id) -> 
    ets:delete(messages, Id).

getById(Id) -> 
    case  ets:lookup(messages, Id) of
        [Message] -> {message,Message};
        [] -> false
    end.