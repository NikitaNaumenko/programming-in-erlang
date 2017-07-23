-module(chapter3).
-export([listlen/1]).
listlen(Y) ->
  case Y of
    [] -> 0;
    [_|Xs] -> 1 + listlen(Xs)
  end.
