- module(simple_compiler).

-compile(export_all).

parse(L) -> parser(lexer(L)).

parser(L) when is_list(L) ->
  {T, []} = expression(L),
  T.

expression(['let',{id,I},'='|T]) ->
  {V, ['in'|R1]} = expression(T),
  {E, R2} = expression(R1),
  {{'let', I, V, E}, R2};
expression(['if'|T]) ->
  {C, ['then'|R1]} = expression(T),
  {X, ['else'|R2]} = expression(R1),
  {Y, R3} = expression(R2),
  {{'if', C, X, Y}, R3};
expression(['~'|T]) -> {X, R} = expression(T), {{'~', X}, R};
expression(['('|T]) -> {X, [')'|R]} = bin(T), {X, R};
expression([{id, _}=X|T]) -> {X, T};
expression([{num, _}=X|T]) -> {X, T}.

bin(L) -> {X, [Op|T]} = expression(L),
  true = lists:member(Op, ['+','-','*', '/']),
  {Y, R} = expression(T),
  {{Op, X, Y}, R}.

get_value(I, D) -> {I, V} = lists:keyfind(I, 1, D), V.

set_value(I, V, D) -> [{I, V}|D].

eval(L) -> evaluator(parse(L)).

evaluator(E) -> evaluator(E, []).

evaluator({'if', C, X, Y}, D) ->
  case evaluator(C, D) == 0 of
    true -> evaluator(X, D);
    false -> evaluator(Y, D)
  end;
evaluator({'let', I, V, E}, D) -> evaluator(E, set_value(I, evaluator(V, D), D));
evaluator({id, I}, D) -> get_value(I, D);
evaluator({num, X}, _D) -> X;
evaluator({'~', X}, D) -> -evaluator(X, D);
evaluator({'+', X, Y}, D) -> evaluator(X, D)+evaluator(Y, D);
evaluator({'-', X, Y}, D) -> evaluator(X, D)-evaluator(Y, D);
evaluator({'*', X, Y}, D) -> evaluator(X, D)*evaluator(Y, D);
evaluator({'/', X, Y}, D) -> evaluator(X, D)/evaluator(Y, D).

pretty_print(X) -> lists:flatten(pp(X)).

pp({'let', I, V, E}) -> "let " ++ [I] ++ " = " ++ [pp(V)] ++ " in " ++ pp(E);
pp({'if', C, X, Y}) -> "if " ++ [pp(C)] ++ " then " ++ [pp(X)] ++ " else " ++ pp(Y);
pp({id, I}) -> I;
pp({num, X}) -> io_lib:write(X);
pp({'~', X}) -> [$~|pp(X)];
pp({'+', X, Y}) -> [$(,pp(X)] ++ " + " ++ [pp(Y),$)];
pp({'-', X, Y}) -> [$(,pp(X)] ++ " - " ++ [pp(Y),$)];
pp({'*', X, Y}) -> [$(,pp(X)] ++ " * " ++ [pp(Y),$)];
pp({'/', X, Y}) -> [$(,pp(X)] ++ " / " ++ [pp(Y),$)].

compile(L) -> compiler(parse(L)).

compiler(L) -> lists:reverse(comp(L)).

comp({id, I}) -> [{get,I}];
comp({num, X}) -> [X];
comp({'~', X}) -> ['~'|comp(X)];
comp({'if', C, X, Y}) -> ['if'|comp(C)++[compiler(X), compiler(Y)]];
comp({'let', I, V, E}) -> comp(E) ++ [{set,I}|comp(V)];
comp({Op, X, Y}) -> [Op|comp(Y) ++ comp(X)].

simulator(L) -> simulator(L, [], []).

simulator([], [X], _D) -> X;
simulator([X|T], S, D) when is_number(X); is_list(X) -> simulator(T, [X|S], D);
simulator(['if'|T], [C,X,_|S], D) when C == 0 -> simulator(X++T, S, D);
simulator(['if'|T], [_,_,Y|S], D) -> simulator(Y++T, S, D);
simulator([{set, I}|T], [V|S], D) -> simulator(T, S, set_value(I, V, D));
simulator([{get, I}|T], S, D) -> simulator(T, [get_value(I, D)|S], D);
simulator(['~'|T], [X|S], D) -> simulator(T, [-X|S], D);
simulator(['+'|T], [Y,X|S], D) -> simulator(T, [X+Y|S], D);
simulator(['-'|T], [Y,X|S], D) -> simulator(T, [X-Y|S], D);
simulator(['*'|T], [Y,X|S], D) -> simulator(T, [X*Y|S], D);
simulator(['/'|T], [Y,X|S], D) -> simulator(T, [X/Y|S], D).

simplify(L) -> simplifier(parse(L)).

simplifier({'/', {num, X}, _}) when X == 0 -> {num, 0};
simplifier({'*', {num, X}, _}) when X == 0 -> {num, 0};
simplifier({'*', _, {num, X}}) when X == 0 -> {num, 0};
simplifier({Op, X, Y}) -> simplifier_({Op, simplifier(X), simplifier(Y)});
simplifier({'~', X}) -> simplifier_({'~', simplifier(X)});
simplifier({'let', I, V, E}) ->
  case simplifier(V) of
    {num, _} = X -> simplifier(subst(I, X, E));
    V2 -> {'let', I, V2, simplifier(E)}
  end;
simplifier({'if', C, X, Y}) ->
  case simplifier(C) of
    {num, N} when N == 0 -> simplifier(X);
    {num, _} -> simplifier(Y);
    C2 -> {'if', C2, simplifier(X), simplifier(Y)}
  end;
simplifier(E) -> E.

simplifier_({'/', {num, X}, _}) when X == 0 -> {num, 0};
simplifier_({'*', {num, X}, _}) when X == 0 -> {num, 0};
simplifier_({'*', _, {num, X}}) when X == 0 -> {num, 0};
simplifier_({'*', {num, X}, E}) when X == 1 -> E;
simplifier_({'*', E, {num, X}}) when X == 1 -> E;
simplifier_({'+', {num, X}, E}) when X == 0 -> E;
simplifier_({'+', E, {num, X}}) when X == 0 -> E;
simplifier_({'-', {num, X}, E}) when X == 0 -> simplifier_({'~', E});
simplifier_({'-', E, {num, X}}) when X == 0 -> E;
simplifier_({'~', {num, X}}) -> {num, -X};
simplifier_(E) -> E.

subst(I, N, {id, I}) -> N;
subst(I, N, {'~', E}) -> {'~', subst(I, N, E)};
subst(I, N, {Op, X, Y}) -> {Op, subst(I, N, X), subst(I, N, Y)};
subst(I, N, {'let', I, V, E}) -> {'let', I, subst(I, N, V), E};
subst(I, N, {'let', I2, V, E}) -> {'let', I2, subst(I, N, V), subst(I, N, E)};
subst(I, N, {'if', C, X, Y}) -> {'if', subst(I, N, C), subst(I, N, X), subst(I, N, Y)};
subst(_, _, E) -> E.


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
