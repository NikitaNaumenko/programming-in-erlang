-module(bool).
-export([b_not/1]).
-export([b_or/1]).
-export([b_and/1]).

b_not(true) ->
  false;
b_not(false) ->
  true.

b_or({ false, true }) ->
  true;
b_or({ false, false }) ->
  false;
b_or({ true, true }) ->
  true;
b_or({ true, false }) ->
  true.


b_and({false, false}) ->
  false;
b_and({true, true}) ->
  true;
b_and({false, true}) ->
  false;
b_and({true, false}) ->
  false.
