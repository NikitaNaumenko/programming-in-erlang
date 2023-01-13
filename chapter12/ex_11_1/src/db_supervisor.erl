-module(db_supervisor).

-export([start_link/0, init/1]).

-behaviour(supervisor).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
  UsrChild = {db, {db, start, []}, permanent, 2000, worker, [db, db_supervisor]},
  {ok,
   {{one_for_all, 1, 3},
    [UsrChild]}}.  % Children = {db, {db, start, []}, permanent, 5000, worker, [db, db_supervisor]},
                   % {ok, {{one_for_all, 1, 3}, [Children]}}.
