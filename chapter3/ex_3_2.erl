-module(ex_3_2).
-export([create/1, reverse_create/1, test/0]).

create(N) -> create(N, []).
create(0, Acc) -> Acc;
create(N, Acc) -> create(N - 1, [N | Acc]).

reverse_create(N) -> reverse_create(1, N, []).
reverse_create(N, N, Acc) -> [N | Acc];
reverse_create(M, N, Acc) -> reverse_create(M + 1, N, [M | Acc]).

test() ->
  [1, 2, 3] = create(3),
  [1, 2, 3, 4] = create(4),
  [3, 2, 1] = reverse_create(3),
  [4, 3, 2, 1] = reverse_create(4),
  ok.
