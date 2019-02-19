-module(bool).
-export([b_not/1, b_and/2, b_or/2, b_nand/2, test/0]).

b_not(true) -> false;
b_not(false) -> true.

b_and(true, true) -> true;
b_and(_, _) -> false.

b_or(false, false) -> false;
b_or(_, _) -> true.

b_nand(X, Y) -> b_not(b_and(X, Y)).

test() ->
  true = b_not(false),
  false = b_and(true, false),
  true = b_and(true, true),
  true = b_or(false, true),
  false = b_or(false, false),
  false = b_nand(true, true),
  true = b_nand(false, true),
  ok.
