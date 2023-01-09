-module(ex_6_2_2_test).

-export([test1/0, test2/0]).
-export([first/0, second/0]).

first() ->
    io:format("~p requesting mutex~n", [self()]),
    ?MODULE:wait(),
    receive cont -> ok end,
    io:format("~p releasing mutex~n", [self()]),
    ?MODULE:signal().

second() ->
    io:format("~p requesting mutex~n", [self()]),
    ?MODULE:wait(),
    ?MODULE:signal().

test1() ->
    F = spawn(?MODULE, first, []),
    S = spawn(mutex_monitor_test, second, []),
    receive after 1000 -> ok end,
    exit(S, kill),
    F ! cont,
    ok.

test2() ->
    F = spawn(?MODULE, first, []),
    spawn(?MODULE, second, []),
    receive after 1000 -> ok end,
    exit(F, kill),
    ok.

