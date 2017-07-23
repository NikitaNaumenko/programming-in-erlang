-module(sum).

-export([safe/1, sum_interval/2, summ/1]).

summ(0) -> 0;
summ(Number) -> Number + summ(Number - 1).

sum_interval(N, M) when N < M ->
    N + sum_interval(N + 1, M);
sum_interval(N, M) when N == M -> N;
sum_interval(N, M) when N > M -> {error, "N > M"}.
