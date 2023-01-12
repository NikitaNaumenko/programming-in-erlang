-module(ex_9_3).
-export([zip/2, zipWith/3, test/0]).

zip(_, []) ->
    [];
zip([], _) ->
    [];
zip([X|Xs], [Y|Ys]) ->
    [{X, Y} | zip(Xs, Ys)].

zipWith(Func, L1, L2) ->
    [Func(X, Y) || {X, Y} <- zip(L1, L2)].

test() ->
  [{1,3}, {2,4}] = zip([1,2],[3,4,5]),
  Add = fun(X, Y) -> X + Y end,
  [4,6] = zipWith(Add, [1,2],[3,4,5]),
  ok.
