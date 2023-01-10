-module(ex_7_2).

-export([foobar/1]).

-record(person, {name, age = 0, phone = "", addr}).

foobar(P) when is_record(P, person) and P#person.name == "joe" -> joe;
foobar(_P) -> noperson.
