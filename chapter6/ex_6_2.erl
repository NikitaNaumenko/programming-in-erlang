-module(ex_6_2).

-export([start/0, stop/0]).
-export([wait/0, signal/0]).
-export([init/0]).

start() ->
        register(?MODULE, spawn(?MODULE, init, [])),
        ok.

init() ->
        process_flag(trap_exit, true),
        free().

wait() ->
        ?MODULE ! {wait, self()},
        receive
                ok ->
                        ok
        end.

signal() ->
        ?MODULE ! {signal, self()},
        ok.

stop() ->
        ?MODULE ! stop.

free() ->
        receive
                {wait, Pid} ->
                        io:format("lock pid ~p ~n", [Pid]),
                        link(Pid),
                        Pid ! ok,
                        busy(Pid);
                {'EXIT', _Pid, normal} ->
                        free();
                stop ->
                        terminate()
        end.

busy(Pid) ->
        receive
                {signal, Pid} ->
                        io:format("unlock pid ~p ~n", [Pid]),
                        unlink(Pid),
                        free();
                {'EXIT', Pid, _Reason} ->
                        io:format("process died ~p ~n", [Pid]),
                        free()
        end.

terminate() ->
        receive
                {wait, Pid} ->
                        exit(Pid, kill),
                        terminate()
        after 0 ->
                ok
        end.

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
    F = spawn(ex_6_2_test, first, []),
    S = spawn(ex_6_2_test, second, []),
    receive after 1000 -> ok end,
    exit(S, kill),
    F ! cont,
    ok.

test2() ->
    F = spawn(ex_6_2_test, first, []),
    spawn(ex_6_2_test, second, []),
    receive after 1000 -> ok end,
    exit(F, kill),
    ok.
