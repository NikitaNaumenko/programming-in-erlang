-module(ex_9_1).

-export([print_numbers/1, less_than/2, print_even/1, concat/1, sum/1, test/0]).

print_numbers(N) ->
  lists:map(fun(Element) -> io:format("~p ~n", [Element]) end, lists:seq(1, N)).

less_than(List, N) ->
  lists:filter(fun(Element) -> Element < N end, List).

print_even(N) ->
  lists:map(fun(Element) -> io:format("~p~n", [Element]) end,
                lists:filter(fun(E) -> E rem 2 == 0 end, lists:seq(1, N))).

concat(List) ->
  lists:foldr(fun(E, Acc) -> E ++ Acc end, [], List).

sum(List) ->
  lists:foldl(fun(E, Acc) -> E + Acc end, 0, List).

test() ->
  List = [1,2,3,4,5],
  [ok,ok,ok,ok,ok] = print_numbers(5),
  [1,2,3] = less_than(List, 4),
  [ok,ok] = print_even(5),
  [1,2,3,4,5,6,7,8,9] = concat([[1,2,3],[4,5,6],[7,8,9]]),
  15 = sum([1,2,3,4,5]),
  ok.

