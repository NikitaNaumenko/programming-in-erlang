-module(ex_5_2).

-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).

start() ->
  register(?MODULE, spawn(?MODULE, init, [])).

init() ->
  Frequencies = {get_frequencies(), []},
  loop(Frequencies).

get_frequencies() ->
  [10, 11, 12, 13, 14, 15].

stop() ->
  call(stop).

allocate() ->
  call(allocate).

deallocate(Freq) ->
  call({deallocate, Freq}).

call(Message) ->
  ?MODULE ! {request, self(), Message},
  receive
    {reply, Reply} ->
      Reply
  end.

allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq | Free], Allocated}, Pid) ->
  ClientFrequencies = keyfilter(Pid, 2, Allocated),
  case length(ClientFrequencies) of
    3 ->
      {{[Freq | Free], Allocated}, {error, exceed_limit}};
    _ ->
      {{Free, [{Freq, Pid} | Allocated]}, {ok, Freq}}
  end.

keyfilter(Key, N, TupleList) ->
  lists:filter(fun(Elem) -> tuple_match(Key, N, Elem) end, TupleList).

tuple_match(Key, N, Tuple) ->
  case lists:keyfind(Key, N, [Tuple]) of
    Tuple ->
      true;
    false ->
      false
  end.

deallocate({Free, Allocated}, Freq, Pid) ->
  case lists:member({Freq, Pid}, Allocated) of
    true ->
      NewAllocated = lists:keydelete(Freq, 1, Allocated),
      {{[Freq | Free], NewAllocated}, ok};
    _ ->
      {{Free, Allocated}, {error, not_allowed}}
  end.

loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    {request, Pid, {deallocate, Freq}} ->
      {NewFrequencies, Reply} = deallocate(Frequencies, Freq, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    {request, Pid, stop} ->
      {_, Allocated} = Frequencies,
      case Allocated of
        [] ->
          reply(Pid, ok);
        _ ->
          reply(Pid, {error, frequencies_in_use}),
          loop(Frequencies)
      end
  end.

reply(Pid, Message) ->
  Pid ! {reply, Message}.
