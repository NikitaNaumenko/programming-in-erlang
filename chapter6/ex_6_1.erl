-module(ex_6_1).

-export([start/0, print/1, loop/0, stop/0]).

start() ->
  register(?MODULE, spawn(?MODULE, loop, [])).

loop() ->
  receive
    {print, Term, Pid} ->
      link(Pid),
      io:format("~p ~n", [Term]),
      loop();
    {stop} ->
      true;
    _ ->
      {error, unknown_message}
  end.

print(Term) ->
  ?MODULE ! {print, Term, self()},
  ok.

stop() ->
  exit(self(), kill),
  ok.
