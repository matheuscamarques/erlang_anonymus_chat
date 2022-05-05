-module(hello_handler).
-behaviour(cowboy_handler).
-export([init/2]).
-export([info/3]).

init(Req0, Opts) ->
	Req = cowboy_req:stream_reply(200, #{
		<<"content-type">> => <<"text/event-stream">>,
        <<"Access-Control-Allow-Origin">> => <<"*">>
	}, Req0),
    pids_repo:insert(self()),
	{cowboy_loop, Req, Opts}.

info(false, Req, State) ->
	{ok, Req, State};
info({message, Msg}, Req, State) ->
    {Id, Text} = Msg,
    Payload = #{
        id => Id,
        event => <<"received_message">>,
        data => Text
    },
	cowboy_req:stream_events(Payload, nofin, Req),
	{ok, Req, State}.
