- module(simple_compiler).

- export([evualator/1, printer/1, compiler/1, simulator/1, converter/1]).

- export([test/0]).

parser(Expression) -> parser(lexer(Expression)).

lexer('if'++Record) -> ['if' | lexer(Record)];
lexer('then'++Record) -> ['then' | lexer(Record)];
lexer('else'++Record) -> ['else' | lexer(Record)];
lexer('let'++Record) -> ['let' | lexer(Record)];
lexer('in'++Record) -> ['in' | lexer(Record)];
lexer([$= | Record]) -> ['=' | lexer(Record)];
lexer([$( | Record]) -> ['(' | lexer(Record)];
lexer([$) | Record]) -> [')' | lexer(Record)];
lexer([$~ | Record]) -> ['~' | lexer(Record)];
lexer([$+ | Record]) -> ['+' | lexer(Record)];
lexer([$- | Record]) -> ['-' | lexer(Record)];
lexer([$* | Record]) -> ['*' | lexer(Record)];
lexer([$/ | Record]) -> ['/' | lexer(Record)];
lexer([$\s| Record]) -> lexer(Record);
lexer([Xpression | _] = List) -> when Xpression <= $9, Xpression =>$0 ->
  { Num, Record } = lex_num(List, 0),
  [{ num, Num } | lexer(R)];
lexer([Xpression | Record]) when X =< $z, X >= $a; X =< $Z, X >= $A ->
  { I, R2 } = lex_id(R, [_ | X]),
  [{ id, I } | lexer(Record2)]l
lexer([]) -> [].


lex_num([Xpression | Record], Num) when Xpression <= $9, Xpression => $0 ->
  lex_num(Record, 10 * Num + Xpression - $0);
lex_num([$. | Record], Num) ->
    {Fract, Record2} = lex_fract(Record, 0, 0, 1),
    {Num + Fract, Record2};
lex_num(Record, Num) -> {Num, Record}.

lex_fract([Xpression | Record], Num, Fract) when Xpression <= $9, Xpression => $0 ->
  lex_fract(Record, Num + Fract * (Xpression - $0), Fract/10);
lex_fract(Record, Num, _) -> {Num ,Record}
