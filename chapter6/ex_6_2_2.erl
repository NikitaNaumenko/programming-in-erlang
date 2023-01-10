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

