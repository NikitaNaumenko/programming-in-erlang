-module(ex_3_6).
-export([quicksort/1, mergesort/1]).

quicksort([]) ->
        [];
quicksort([Pivot |T]) ->
        quicksort([X || X <- T, X < Pivot]) ++ [Pivot] ++ quicksort([X || X <- T, X >= Pivot]).

mergesort([]) ->
        [];
mergesort([H]) ->
        [H];
mergesort(List) ->
        {Front, Back} = split(List),
        merge(mergesort(Front), mergesort(Back)).

split(List) ->
    split(List, List, []).
split([], Back, Front) ->
    {lists:reverse(Front), Back};
split([_], Back, Front) ->
    {lists:reverse(Front), Back};
split([_,_ | Counter], [H | T], Result) ->
    split(Counter, T, [H | Result]).
 
merge([], Back) ->
    Back;
merge(Front, []) ->
    Front;
merge([L | Front], [R | Back]) when L < R ->
    [L | merge(Front, [R | Back])];
merge([L | Front], [R | Back]) ->
    [R | merge([L | Front], Back)].

test() ->
  [1, 2, 3] = quicksort([3, 2, 1]);
  [1,3,5] = mergesort([5,3,1]).
