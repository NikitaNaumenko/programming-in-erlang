-module(ex_6_2_2).

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
                        Ref = erlang:monitor(process, Pid),
                        Pid ! ok,
                        busy(Pid, Ref);
                {'DOWN', _Reference, process, _Pid, _Reason} ->
                        free();
                stop ->
                        terminate()
        end.

busy(Pid, Ref) ->
        receive
                {signal, Pid} ->
                        io:format("unlock pid ~p ~n", [Pid]),
                        erlang:demonitor(Ref, [flush]),
                        free();
                {'DOWN', _Reference, process, Pid, Reason} ->
                        io:format("process died ~p: ~s~n", [Pid, Reason]),
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
    F = spawn(mutex_monitor_test, first, []),
    S = spawn(mutex_monitor_test, second, []),
    receive after 1000 -> ok end,
    exit(S, kill),
    F ! cont,
    ok.

test2() ->
    F = spawn(mutex_monitor_test, first, []),
    spawn(mutex_monitor_test, second, []),
    receive after 1000 -> ok end,
    exit(F, kill),
    ok.

