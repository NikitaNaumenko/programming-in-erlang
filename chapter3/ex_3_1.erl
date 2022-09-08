-module(ex_3_1).
-export([sum/1, sum/2, test/0]).

sum(0) -> 0;
sum(Number) -> Number + sum(Number - 1).

sum(N, M) when N < M ->
  N + sum(N + 1, M);
sum(N, M) when N == M ->
  M;
sum(N, M) when N > M ->
  { errors, "N > M" }.

test() ->
  15 = sum(5),
  6 = sum(3),
  6 = sum(1, 3),
  6 = sum(6, 6),
  ok.
