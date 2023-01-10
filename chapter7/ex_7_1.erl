-module(ex_7_1).

-export([birthday/1, joe/0, showPerson/1]).

-record(person, {name, age = 0, phone = "", addr}).

birthday(#person{age = Age} = P) ->
  P#person{age = Age + 1}.

joe() ->
  #person{name = "Joe",
          age = 35,
          phone = "12345",
          addr = "addr"}.

showPerson(#person{name = Name,
                   age = Age,
                   phone = Phone,
                   addr = Addr}) ->
  io:format("Person: Name - ~p, Age - ~p, phone - ~p, Addr - ~p~n",
            [Name, Age, Phone, Addr]).
