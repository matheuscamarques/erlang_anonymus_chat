%%%-------------------------------------------------------------------
%% @doc backend public API
%% @end
%%%-------------------------------------------------------------------

-module(backend_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    pids_repo:start(),
    messages_repo:start(),
    sender_service:start(),

    Dispatch = cowboy_router:compile([
        { '_', [
            {"/", cowboy_static, {file, "front_end/index.html"}},
            {"/app/[...]", cowboy_static, {dir, "front_end/app"}},
            {"/events", events_handler, []},
            {"/message", message_handler, []}
        ] }
    ]),
    {ok, _} = cowboy:start_clear(
        hello_listener,
        [{port, 80}],
        #{env => #{dispatch => Dispatch}}
    ),
    backend_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
