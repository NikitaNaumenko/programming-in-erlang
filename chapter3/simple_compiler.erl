- module(simple_compiler).

-compile(export_all).

%- export([evualator/1, printer/1, compiler/1, simulator/1, converter/1]).

%- export([test/0]).

parser(Expression) -> parser(lexer(Expression)).


lexer("if"++R) -> ['if'|lexer(R)];
lexer("then"++R) -> ['then'|lexer(R)];
lexer("else"++R) -> ['else'|lexer(R)];
lexer("let"++R) -> ['let'|lexer(R)];
lexer("in"++R) -> ['in'|lexer(R)];
lexer([$=|R]) -> ['='|lexer(R)];
lexer([$(|R]) -> ['('|lexer(R)];
lexer([$)|R]) -> [')'|lexer(R)];
lexer([$~|R]) -> ['~'|lexer(R)];
lexer([$+|R]) -> ['+'|lexer(R)];
lexer([$-|R]) -> ['-'|lexer(R)];
lexer([$*|R]) -> ['*'|lexer(R)];
lexer([$/|R]) -> ['/'|lexer(R)];
lexer([$\s|R]) -> lexer(R);
lexer([X|_] = L) when X =< $9, X >= $0 ->
  {Num, R} = lex_num(L, 0),
  [{num, Num}|lexer(R)];
lexer([X|R]) when X =< $z, X >= $a; X =< $Z, X >= $A ->
  {I, R2} = lex_id(R, [X]),
  [{id, I}|lexer(R2)];
lexer([]) -> [].

lex_num([X|R], N) when X =< $9, X >= $0 ->
  lex_num(R, 10*N + X - $0);
lex_num([$.|R], N) ->
  {F, R2} = lex_fract(R, 0, 0.1),
  {N + F, R2};
lex_num(R, N) -> {N, R}.

lex_fract([X|R], N, F) when X =< $9, X >= $0 ->
  lex_fract(R, N + F * (X - $0), F/10);
lex_fract(R, N, _) -> {N, R}.

lex_id([X|R], I) when X =< $z, X >= $a; X =< $Z, X >= $A; X =< $9, X >= $0 ->
  lex_id(R, [X|I]);
lex_id(R, I) -> {lists:reverse(I), R}.
