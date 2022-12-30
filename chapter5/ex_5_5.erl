-module(ex_5_5).

-export([start/0, stop/0]).
-export([idle/0, ringing/1]).
-export([incoming/1, off_hook/0, off_hook/1, other_on_hook/1, on_hook/0, on_hook/1,
         connect/1]).
-export([init/0]).

start() ->
  start_handler(),
  register(?MODULE, spawn(?MODULE, init, [])),
  ok.

stop() ->
  stop_handler(),
  ok.

init() ->
  idle().

incoming(Number) ->
  ?MODULE ! {Number, incoming}.

off_hook() ->
  ?MODULE ! off_hook.

off_hook(Number) ->
  ?MODULE ! {Number, off_hook}.

other_on_hook(Number) ->
  ?MODULE ! {Number, other_on_hook}.

on_hook() ->
  ?MODULE ! on_hook.

on_hook(Number) ->
  ?MODULE ! {Number, on_hook}.

connect(Number) ->
  ?MODULE ! {Number, other_off_hook}.

idle() ->
  receive
    {Number, incoming} ->
      start_ringing(Number),
      ringing(Number);
    off_hook ->
      start_tone(),
      dial()
  end.

ringing(Number) ->
  receive
    {_Number, other_on_hook} ->
      stop_ringing(),
      idle();
    {Number, off_hook} ->
      stop_ringing(Number),
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

% Actions
start_ringing(Number) ->
  send_event({incoming, 10, Number}).

stop_ringing() ->
  ok.

stop_ringing(Number) ->
  send_event({accept_incoming, 20, Number}).

start_tone() ->
  ok.

stop_tone() ->
  ok.

start_conversation(Number) ->
  send_event({start_outgoing, 20, Number}).

stop_conversation(Number) ->
  send_event({stop_conversation, 30, Number}).

% Wrappers
start_handler() ->
  ex_5_3:start(billing, [{log_handler, "phone.log"}]).

stop_handler() ->
  ex_5_3:stop(billing).

send_event(Data) ->
  ex_5_3:send_event(billing, Data).
