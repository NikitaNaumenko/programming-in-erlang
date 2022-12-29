-module(ex_5_4).

-export([init/1, terminate/1, handle_event/2]).

init(State) ->
        State.

terminate(State) ->
        {data, State}.

handle_event({Type, _Id, Description}, State) ->
        case lists:keysearch({Type, Description}, 1, State) of
                false ->
                        [{{Type, Description}, 1} | State];
                {value, {{Type, Description}, Count}} ->
                        lists:keyreplace({Type, Description}, 1, State, {{Type, Description}, Count + 1})
        end.
