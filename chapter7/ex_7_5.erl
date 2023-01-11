-module(ex_7_5).

-export([sum/1, max/1, min/1, is_ordered/1, insert/2, test/0]).

-record(btree, {value, left = [], right = []}).

sum([]) ->
  0;
sum(#btree{value = Value,
           left = Left,
           right = Right}) ->
  Value + sum(Left) + sum(Right).

max([]) ->
  [];
max(#btree{value = Value,
           left = Left,
           right = Right}) ->
  lists:max(
    lists:filter(fun erlang:is_number/1, [Value, max(Left), max(Right)])).

min([]) ->
  [];
min(#btree{value = Value,
           left = Left,
           right = Right}) ->
  lists:min(
    lists:filter(fun erlang:is_number/1, [Value, max(Left), max(Right)])).

is_ordered([]) ->
  true;
is_ordered(#btree{value = Value,
                  left = Left,
                  right = Right}) ->
  (Left == [] orelse is_ordered(Left) andalso max(Left) =< Value)
  andalso (Right == [] orelse is_ordered(Right) andalso min(Right) >= Value).

insert([], NewValue) ->
  #btree{value = NewValue};
insert(#btree{value = Value, left = Left} = Tree, NewElem) when NewElem < Value ->
  Tree#btree{left = insert(Left, NewElem)};
insert(#btree{right = Right} = Tree, NewElem) ->
  Tree#btree{right = insert(Right, NewElem)}.

test() ->
  Tree =
    #btree{value = 3,
           left = #btree{value = 2},
           right =
             #btree{value = 4,
                    left = #btree{value = 3},
                    right = #btree{value = 5}}},
  5 = max(Tree),
  2 = min(Tree),
  17 = sum(Tree),
  true = is_ordered(Tree),
  #btree{value = 3,
         left = #btree{value = 2},
         right =
           #btree{value = 4,
                  left = #btree{value = 3},
                  right = #btree{value = 5, right = #btree{value = 6}}}} =
    insert(Tree, 6),
    ok.
