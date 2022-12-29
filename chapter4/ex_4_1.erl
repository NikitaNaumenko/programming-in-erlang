-module(ex_4_1).

-export([start/0, stop/0, print/1, loop/0]).

start() ->
  register(?MODULE, spawn(?MODULE, loop, [])),
  ok.

print(Term) ->
  ?MODULE ! Term.

stop() ->
  ?MODULE ! stop.

loop() ->
  receive
    stop ->
      true;
    Message ->
      io:format("~p~n", [Message]),
      loop()
  end.
