-module(ex_3_5).
-export([filter/2, reverse/1, concatenate/1, test/0]).

filter([], _) -> [];
filter([H | T], Key) when H =< Key -> [H | filter(T, Key)];
filter([_ | T], Key) -> filter(T, Key).

reverse(List) -> reverse(List, []).
reverse([], Acc) -> Acc;
reverse([H | T], Acc) -> reverse(T, [H | Acc]).

concatenate([]) -> [];
concatenate([H | T]) when is_list(H) -> append(H, concatenate(T)).

append([H|T], Tail) ->
    [H|append(T, Tail)];
append([], Tail) ->
    Tail.

flatten([]) -> [];
flatten([H | T]) -> append(flatten(H), flatten(T));
flatten(List) -> [List].

test() ->
  [1, 2, 3] = filter([1, 2, 3, 4, 5, 6], 3),
  [3, 2, 1] = reverse([1, 2, 3]),
  [1, 2, 3, 4, five] = concatenate([[1,2,3,4], [], [five]]),
  [1,2,3,4,5,6] = flatten([[1,[2,[3],[]]], [[[4]]], [5,6]]),
  ok.
