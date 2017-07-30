- module(trans).

- export([filter/2, concatenate/1, reverse/1, flatten/1, test/0]).

filter(Lst, Element) -> filter(Lst, Element, []).
filter([], _, Newlist) -> lists:reverse(Newlist);
filter([H|T], Element, Newlist) ->
  if
     H =< Element -> filter(T, Element, [H|Newlist]);
     true -> filter(T, Element, Newlist)
 end.

reverse(Lst) -> reverse(Lst, []).
reverse([], Newlist) -> Newlist;
reverse([H|T], Newlist) -> reverse(T, [H|Newlist]).

concatenate(Lst) -> concatenate(Lst, []).
concatenate([],Newlist) -> Newlist;
concatenate([H|T], Newlist) -> concatenate(T, Newlist++H).

helper(Lst) -> helper(Lst, []).
helper([], Newlist) -> Newlist;
helper([H|T], Newlist) ->
  if
    is_list(H)->
      helper(T, helper(H) ++ Newlist);
    true ->
      helper(T, [H] ++ Newlist)
  end.
flatten(Lst) -> reverse(helper(Lst)).

test() ->
    [1,2,3] = filter([1,2,3,4,5], 3),
    [3,2,1] = reverse([1,2,3]),
    [1,2,3,4,five] = concatenate([[1,2,3], [], [4, five]]),
    [1,2,3,4,5,6] = flatten([[1,[2,[3],[]]], [[[4]]], [5,6]]),
    ok.
