-module(echo).

-export([go/0, loop/0]).

go() ->
  register(echo, spawn(?MODULE, loop, [])),
  echo ! {self(), hello},
  receive
    {Pid, Message} ->
      io:format("~w~n", [Message])
  end.

  % Pid ! stop.

loop() ->
  receive
    {From, Message} ->
      From ! {self(), Message},
      loop();
    stop ->
      true
  end.
