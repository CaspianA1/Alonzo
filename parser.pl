variable(var(A)) -->
	[A], {\+ member(A, ['=', '\\', '.', '(', ')']), atom(A)}.

assignment([assigning(A), to(B)]) -->
	variable(A), ['='], (expr_type_1(B); expr_type_2(B)).

abstraction([lambda(Var, Expr)]) -->
	['\\'], variable(Var), ['.'], (expr_type_1(Expr); expr_type_2(Expr)).

application([calling(F), with(A)]) -->
	(variable(F); expr_type_2(F)), (expr_type_1(A); expr_type_2(A)).

expr_type_1(E) -->
	assignment(E); variable(E); abstraction(E); application(E).

expr_type_2(E) -->
	['('], (abstraction(E); application(E)), [')'].

parse(Tokens, AST) :-
	phrase(expr_type_1(AST), Tokens);
	phrase(expr_type_2(AST), Tokens).