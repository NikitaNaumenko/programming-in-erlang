- module(sort_lists_3_6).
- export([fast_sort/1,  merge_sort/1]).
- export([test/0]).

quicksort([]) -> [];
quicksort([Head | Tail]) ->
  [Less| Greater] -> split([Head, Tail, [],[]]),
  quicksort(Less) ++ [Head] ++ quicksort(Greater)

split(Head,[F|T], Less, Greater) when TailHead < Head -> split(Head, Tail,[F|T], Greater);
split(Head,[F|T], Less, Greater) -> split(Head, Tail, Less, [F|T]);
split(_, [], Less, Greater) -> [L, H]


merge_sort([]) -> [];
merge_sort(R)->
  [R] = merge([[X]||X<-L]),
  R.

merge([])-> [];
merge([A, B|T]) -> merger([merge(A, B)| merge(T)]);
merge([A]) -> [A].

merge([A|TA], [B|_] = LB) when A<B -> [A|merge(TA, LB)];
merge([_|_] = LA, [B|TB]) -> [B|merge(LA, TB)];
merge([], LB) -> LB;
merge(LA, []) -> LA.
