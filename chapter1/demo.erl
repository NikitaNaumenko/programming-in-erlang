-module(demo).
-export([double/1]).
-import(math,[sqrt/1]).

area({triangle, A, B, C}) ->
  S = (A + B + C)/2,
  sqrt(S * (S-A) * (S-B)* (S-C)).

double(Value) ->
  times(Value, 2).
times(X, Y) ->
  X * Y.
