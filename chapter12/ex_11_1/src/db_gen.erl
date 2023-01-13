-module(db_gen).
-export([write/2, read/2, match/2, delete/2]).

write({Key, Element}, Data) ->
    {ok, [{Key, Element}|lists:keydelete(Key, 1, Data)]}.

read(Key, Data) ->
    case lists:keyfind(Key, 1, Data) of
        false ->
            {{error, instance}, Data};
        {_, Element} ->
            {{ok, Element}, Data}
    end.

match(Element, Data) -> 
    Reply = [Key || {Key, X} <- Data, X =:= Element], 
    {Reply, Data}.

delete(Key, Data) ->
    {ok, lists:keydelete(Key, 1, Data)}.
