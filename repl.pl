multi_load_env([], Final_Env, Final_Env).
multi_load_env([Expr | Exprs], Env, New_New_Env) :-
	atom_chars(Expr, Chars),
	tokenize(Chars, Tokens),
	parse(Tokens, AST),
	eval(AST, Env, New_Env, _),
	multi_load_env(Exprs, New_Env, New_New_Env).

read_input(Output) :-
	get_char(Char),
	(Char = '\n' -> Output = '';
		read_input(Next),
		atom_concat(Char, Next, Output)).

repl_actions(Env, [':d']) :- trace, repl(Env).
repl_actions(_, [':q']) :- halt.
repl_actions(_, _).

to_printable('Assignment.', 'Assignment.').
to_printable([error, Message], Message).
to_printable(closure(L, _), [L]).

no_op.
repl(Env) :-
	write('λ > '),
	read_input(Expr),
	atom_chars(Expr, Chars),
	tokenize(Chars, Tokens),
	(Tokens = [] -> repl(Env); no_op),
	repl_actions(Env, Tokens),
	parse(Tokens, AST),
	eval(AST, Env, New_Env, Result),
	(to_printable(Result, PR) -> write(PR), nl),
	(New_Env = Env -> repl(Env); repl(New_Env)).

main :-
	consult([tokenizer, parser, evaluator]),

	Builtins = 
		['true = \\x. \\y. x', 'false = \\x. \\y. y',
		'if = \\state. \\t. \\f. (state t) f',
		'and = \\a. \\b. ((if a) b) false',
		'or = \\a. \\b. ((if a) true) b',
		'not = \\a. ((if a) false) true',
		'id = \\a. a'],

	multi_load_env(Builtins, [], Env),
	repl(Env).