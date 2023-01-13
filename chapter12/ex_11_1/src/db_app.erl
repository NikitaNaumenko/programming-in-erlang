-module(db_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _StartArgs) ->
  db_supervisor:start_link().

stop(_State) ->
  ok.
