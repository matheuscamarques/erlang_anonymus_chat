-module(message_handler).
-export([
    init/2,
    allowed_methods/2,
    content_types_provided/2,
    content_types_accepted/2,
    post_handler/2,
    options/2
]).


init(Req, Opts) ->
    {cowboy_rest, Req, Opts}.

options(Req, State) ->
    Req1 = cowboy_req:set_resp_header(<<"access-control-allow-methods">>, <<"POST, OPTIONS">>, Req),
    Req2 = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req1),
    Req3 = cowboy_req:set_resp_header(<<"access-control-allow-headers">>, <<"content-type">>, Req2),
    {ok, Req3, State}.

allowed_methods(Req, State) ->
    {[<<"POST">>,<<"OPTIONS">>], Req, State}.

content_types_accepted(Req, State) ->
    {[
        {{<<"application">>, <<"json">>, '*'}, post_handler}
        ], Req, State}.

content_types_provided(Req, State) ->
    {
        [
            {<<"application/json">>, post_handler}
        ],
        Req,
        State
    }.

% Create new Post
post_handler(Req0 = #{method := <<"POST">>}, State) ->
    {ok, Data, Req1} = cowboy_req:read_body(Req0),
    Message     = jiffy:decode(Data,[return_maps]),
    Text = maps:get(<<"text">>,Message),
    Id      = messages_repo:insert({Text}),
    Req2    = cowboy_req:set_resp_body(Id, Req1),
    Req3    = cowboy_req:set_resp_header(<<"access-control-allow-origin">>, <<"*">>, Req2),
    {true, Req3, State}.


    