-module(db).
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2, test/0]).

new() -> [].

destroy(Db) when is_list(Db) -> ok.
write(Key, Element, Db) -> [{Key, Element} | delete(Key, Db)].

delete(Key, [{Key, _} | Tail]) -> Tail;
delete(Key, [Head | Tail]) -> [Head | delete(Key, Tail)];
delete(_, []) -> [].

read(_, []) -> {error, instance};
read(Key, [{Key, Element} | _]) -> {ok, Element};
read(Key, [{_, _} | Db]) -> read(Key, Db).

match(Element, [{Key, Element} | Tail]) -> [Key | match(Element, Tail)];
match(Element, [_| Tail]) -> match(Element, Tail);
match(_, []) -> [].

test() ->
    [] = Db = db:new(),
    [{francesco, london}] = Db1 = db:write(francesco, london, Db),
    [{lelle, stockholm}, {francesco, london}] = Db2 = db:write(lelle, stockholm, Db1),
    {ok, london} = db:read(francesco, Db2),
    [{joern, stockholm}, {lelle, stockholm}, {francesco, london}] = Db3 = db:write(joern, stockholm, Db2),
    [joern, lelle] = db:match(stockholm, Db3),
    [{joern, stockholm}, {francesco, london}] = Db4 = db:delete(lelle, Db3),
    [{francesco, prague}, {joern, stockholm}] = db:write(francesco, prague, Db4),
    [joern] = db:match(stockholm, Db4),
    ok.
