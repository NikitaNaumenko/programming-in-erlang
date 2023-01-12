-module(db).

-export([new/0, destroy/1, write/3, delete/2, read/2, match/2, code_upgrade/1]).
-vsn(1.0).

new() ->
    [].

destroy(Db) when is_list(Db) ->
    ok.

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

code_upgrade(RecordList) ->
  gb_trees:from_orddict(RecordList).

