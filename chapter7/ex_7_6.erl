% First compile without 'show' option
% $ erlc ex_7_6.erl
% end run inside erl
% ex_7_6:test()
% then
% $ erlc -Dshow ex_7_6.erl
% end run inside erl
% ex_7_6:test()

-module(ex_7_6).

-export([test/0]).

-ifdef(show).
    -define(SHOW_EVAL(Exp), 
    (fun(Arg)->io:format("Exp=~p,Val=~p~n",[??Exp, Arg]),Arg end)(Exp)).
-else.
    -define(SHOW_EVAL(Exp),Exp).
-endif.

test() ->
  Max = ?SHOW_EVAL(lists:max([1, 2, 3, 4])),
  io:format("Printining from test: ~p~n", [Max]).
