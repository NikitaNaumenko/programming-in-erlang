-module(ex_9_4).

% -export([map/2, filter/2, reduce/2, test/0]).
-export([map/2, filter/2, reduce/3, test/0]).

map(_Fn, []) ->
  [];
map(Fn, List) ->
  map(Fn, List, []).

map(_Fn, [], NewList) ->
  reverse(NewList);
map(Fn, [Head | Tail], NewList) ->
  NewHead = Fn(Head),
  map(Fn, Tail, [NewHead | NewList]).

filter(_Fn, []) ->
  [];
filter(Fn, List) ->
  filter(Fn, List, []).

filter(_Fn, [], NewList) ->
  reverse(NewList);
filter(Fn, [Head | Tail], NewList) ->
  case Fn(Head) of
    true ->
      filter(Fn, Tail, [Head | NewList]);
    _ ->
      filter(Fn, Tail, NewList)
  end.

reduce(_Fn, [], Acc) ->
  Acc;
reduce(Fn, [Head | Tail], Acc) ->
  NewAcc = Fn(Head, Acc),
  reduce(Fn, Tail, NewAcc).
reverse(L) ->
  reverse(L, []).

reverse([], Acc) ->
  Acc;
reverse([H | T], Acc) ->
  reverse(T, [H | Acc]).

test() ->
  [2, 4, 6] = map(fun(X) -> X * 2 end, [1, 2, 3]),
  [2,4] = filter(fun(X) -> X rem 2 == 0 end, [1,2,3,4,5]),
  15 = reduce(fun(X, Acc) -> X + Acc end, [1,2,3,4,5], 0),
  ok.
