- module(db_3_7).
- export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).
- export([test/0]).

% db_3_7:new() => Db.
% db_3_7:destroy(Db) => ok.
% db_3_7:write(Key, Element, Db) => NewDb.
% db_3_7:delete(Key, Db) => NewDb.
% db_3_7:read(Key, Db) => {ok, Element} | {error, instance}.
% db_3_7:match(Element, Db) => [Key1, ..., KeyN].


new() ->
  [].

destroy(Db) when is_list(Db) ->
  ok.

write(Key, Element, Db) ->
  [{Key, Element} | lists:keydelete(Key, 1, Db)].


delete(Key, Db) ->
  lists:keydelete(Key, 1, Db).

read(Key, Db) ->
  read(lists:keyfind(Key, 1, Db)).
read(false) ->
  {error, instance};
read({ _, Element }) ->
  ({ ok, Element }).

match(Element, Db) ->
  [Key || { Key, X } <- Db, X =:= Element].

test() ->
  [] = Db = db_3_7:new(),
  [{francesco, london}] = Db1 = db_3_7:write(francesco, london, Db),
  [{lelle, stockholm}, {francesco, london}] = Db2 = db_3_7:write(lelle, stockholm, Db1),
  {ok, london} = db_3_7:read(francesco, Db2),
  [{joern, stockholm}, {lelle, stockholm},
   {francesco, london}] = Db3 = db_3_7:write(joern, stockholm, Db2),
  % {error, instance} = db:read(ola, Db3),
  [joern, lelle] = db_3_7:match(stockholm, Db3),
  [{joern, stockholm}, {francesco, london}] = Db4 = db_3_7:delete(lelle, Db3),
  [{francesco, prague}, {joern, stockholm}] = db_3_7:write(francesco, prague, Db4),
  [joern] = db_3_7:match(stockholm, Db4),
  ok.
