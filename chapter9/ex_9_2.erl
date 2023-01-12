-module(ex_9_2).

-export([test/0, div3/0, int_seq/1, intersection/2, symdiff/2]).

div3() ->
  [X || X <- lists:seq(1, 10), X rem 3 == 0].

int_seq(L) ->
  [X * X || X <- L, is_integer(X)].

intersection(L1, L2) ->
  [X || X <- L1, Y <- L2, X == Y].

symdiff(L1, L2) ->
  [X || X <- L1, not lists:member(X, L2)] ++ [X || X <- L2, not lists:member(X, L1)].

test() ->
  [3, 6, 9] = div3(),
  [1, 10000, 1000000] = int_seq([1, "ll", 100, "jsjsj", 1000]),
  [1, 2, 3, 100] = intersection([1, 5, 2, 10, 3, 100], [1, 2, 24, 3, 100]),
  [5, 10, 24] = symdiff([1, 5, 2, 10, 3, 100], [1, 100, 2, 24, 3, 100]),
  ok.
