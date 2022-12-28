- module(fsm).
- export([idle/0, ringing/1]).
- export([init/0])

start() ->
  register(?MODULE, spawn(?MODULE, init, [])).

init() ->
  idle().

incoming(Number) -> phone ! {Number, incoming}.
off_hook() -> phone ! off_hook.
off_hook(Number) -> phone ! {Number, off_hook}.
other_on_hook(Number) -> phone ! {Number, other_on_hook}.
on_hook() -> phone ! on_hook.
on_hook(Number) -> phone ! {Number, on_hook}.
connect(Number) -> phone ! {Number, other_off_hook}.

idle() ->
  receive
    {Number, incoming} ->
      start_ringing(),
      ringing(Number);
    off_hook ->
      start_tone(),
      dial()
  end.

ringing(Number) ->
  receive
    {Number, other_on_hook} ->
      stop_ringing(),
      idle();
    {Number, off_hook} ->
      stop_ringing(),
      connected(Number)
  end.

connected(Number) ->
  receive
    {Number, on_hook} ->
      stop_conversation(Number),
      idle()
  end.

dial() ->
  receive
    on_hook ->
      stop_tone(),
      idle();
    {other_off_hook, Number} ->
      start_conversation(Number),
      connected(Number)
  end.
% start_ringing()->.
% start_tone() ->.
% stop_ringing() ->.

