-module(ex_6_3_test).
-export([test1/0, test2/0, test3/0, test4/0]).
-export([test5/0, test6/0]).

test1() ->
    ex_6_3:start_link(ex_6_3, [{echo3, start, [], permanent, 5}]),
    receive after 1000 -> ok end,
    exit(whereis(echo3), kill),
    receive after 1000 -> ok end,
    ex_6_3:stop(ex_6_3).
test2() ->
    ex_6_3:start_link(ex_6_3, [{echo3, start, [], permanent, 5}]),
    receive after 1000 -> ok end,
    echo3 ! stop,
    receive after 1000 -> ok end,
    ex_6_3:stop(ex_6_3).

test3() ->
    ex_6_3:start_link(ex_6_3, [{echo3, start, [], transient, 5}]),
    receive after 1000 -> ok end,
    exit(whereis(echo3), kill),
    receive after 1000 -> ok end,
    ex_6_3:stop(ex_6_3).

test4() ->
    ex_6_3:start_link(ex_6_3, [{echo3, start, [], transient, 5}]),
    receive after 1000 -> ok end,
    echo3 ! stop,
    receive after 1000 -> ok end,
    ex_6_3:stop(ex_6_3).

test5() ->
    ex_6_3:start_link(ex_6_3, [{echo3, start, [], permanent, 5}]),
    receive after 1000 -> ok end,
    test5_loop(),
    ex_6_3:stop(ex_6_3).

test5_loop() ->
    echo3 ! stop,
    receive after 1000 -> ok end,
    case whereis(echo3) of
        undefined -> ok;
        Pid ->
            test5_loop()
    end.

test6() ->
    ex_6_3:start_link(ex_6_3, []),
    {Pid, Id, Spec} = ex_6_3:start_child(ex_6_3, echo3, start, []),
    ex_6_3:stop_child(ex_6_3, Id),
    receive after 1000 -> ok end,
    ex_6_3:stop(ex_6_3).
