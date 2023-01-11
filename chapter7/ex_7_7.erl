-module(ex_7_7).
-export([test/0]).

-ifdef(debug).
    -define(count(Fun), io:format(standard_error, "~p:~p called~n", [?MODULE, Fun])).
-else.
    -define(count(Fun), ok).
-endif.


max(List) ->
  lists:max(List).
test() ->
  max([1,2,3]),
  max([1,2,3]),
  max([1,2,3]),
  max([1,2,3]),
  ?count(fun max/1).
