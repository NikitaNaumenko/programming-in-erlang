-module(ex_5_1).

-export([start/0, stop/0, write/2, delete/1, read/1, match/1, test/0]).
-export([init/0]).

start() ->
  register(?MODULE, spawn(?MODULE, init, [])).

init() ->
  loop([]).

stop() ->
  ?MODULE ! stop,
  ok.

write(Key, Value) ->
  call(write, {Key, Value}).

delete(Key) ->
  call(delete, Key).

read(Key) ->
  call(read, Key).

match(Key) ->
  call(match, Key).

loop(Db) ->
  receive
    {write, Pid, {Key, Value}} ->
      NewDb = write(Key, Value, Db),
      reply(Pid, ok),
      loop(NewDb);
    {delete, Pid, Key} ->
      NewDb = delete(Key, Db),
      reply(Pid, ok),
      loop(NewDb);
    {read, Pid, Key} ->
      Value = read(Key, Db),
      reply(Pid, Value),
      loop(Db);
    {match, Pid, Key} ->
      Values = match(Key, Db),
      reply(Pid, Values),
      loop(Db);
    stop ->
      ok
  end.

call(Command, Value) ->
  ?MODULE ! {Command, self(), Value},
  receive
    {reply, Reply} ->
      Reply
  end.

reply(Pid, Msg) ->
  Pid ! {reply, Msg}.

write(Key, Element, Db) ->
  [{Key, Element} | delete(Key, Db)].

delete(Key, [{Key, _} | Tail]) ->
  Tail;
delete(Key, [Head | Tail]) ->
  [Head | delete(Key, Tail)];
delete(_, []) ->
  [].

read(_, []) ->
  {error, instance};
read(Key, [{Key, Element} | _]) ->
  {ok, Element};
read(Key, [{_, _} | Db]) ->
  read(Key, Db).

match(Element, [{Key, Element} | Tail]) ->
  [Key | match(Element, Tail)];
match(Element, [_ | Tail]) ->
  match(Element, Tail);
match(_, []) ->
  [].

test() ->
  ?MODULE:start(),
  ok = ?MODULE:write(key, value),
  {ok, value} = ?MODULE:read(key),
  ok = ?MODULE:delete(key),
  {error, instance} = ?MODULE:read(key),
  ok = ?MODULE:write(key, value),
  ok = ?MODULE:write(new_key, value),
  [new_key, key] = ?MODULE:match(value),
  ?MODULE:stop().
