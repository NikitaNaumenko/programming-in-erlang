% Exercise 3.2
% The function create returns new lists:
% The function reverse create returns new reverse list
- module(new_list).

-export([create/1, reverse_create/1, test/0]).

create(N) -> create(N, []).
create(0, Acc) -> Acc;
create(N, Acc) -> create(N-1, [N|Acc]).

reverse_create(N) -> reverse_create(1, N, []).
reverse_create(N, N, Acc) -> [N|Acc];
reverse_create(N, M, Acc) -> reverse_create(N+1, M, [N|Acc]).

test() ->
  [1,2,3] = create(3),
  [3,2,1] = reverse_create(3),
  ok.
