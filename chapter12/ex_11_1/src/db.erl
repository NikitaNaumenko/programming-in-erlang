-module(db).

-export([start/0, stop/0]).
-export([write/2, delete/1, read/1, match/1]).
-export([init/1, terminate/2, handle_call/3, handle_cast/2]).

-behaviour(gen_server).

start() ->
  start_link().

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
  gen_server:cast(?MODULE, stop).

init(_Args) ->
  {ok, []}.

terminate(_Reason, _State) ->
  ok.

write(Key, Value) ->
  gen_server:call(?MODULE, {write, Key, Value}).

read(Key) ->
  gen_server:call(?MODULE, {read, Key}).

delete(Key) ->
  gen_server:call(?MODULE, {delete, Key}).

match(Key) ->
  gen_server:call(?MODULE, {match, Key}).

handle_call({write, Key, Value}, _From, State) ->
  {Reply, NewState} = db_gen:write({Key, Value}, State),
  {reply, Reply, NewState};
handle_call({read, Key}, _From, State) ->
  {Reply, NewState} = db_gen:read(Key, State),
  {reply, Reply, NewState};
handle_call({delete, Key}, _From, State) ->
  {Reply, NewState} = db_gen:delete(Key, State),
  {reply, Reply, NewState};
handle_call({match, Key}, _From, State) ->
  {Reply, NewState} = db_gen:math(Key, State),
  {reply, Reply, NewState}.

handle_cast(stop, State) ->
  {stop, normal, State}.
