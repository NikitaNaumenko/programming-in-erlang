-module(ex_3_3).

-export([new_print/1, even_print/1, test/0]).

new_print(0) ->
  io:format("Number: ~p~n", [0]);
new_print(N) ->
  io:format("Number: ~p~n", [N]),
  new_print(N - 1).

even_print(0) ->
  io:format("Number: ~p~n", [0]);
even_print(N) when N rem 2 == 0 ->
  io:format("Number: ~p~n", [N]),
  even_print(N - 1);
even_print(N) ->
  even_print(N - 1).

test() ->
  ok = new_print(8),
  ok.
