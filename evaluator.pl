% turning a non-capturing anonymous function into a capturing one
eval([lambda(A, B)], Global_Env, _, closure(lambda(A, B), capturing(Global_Env))).

% one-time assignment
eval([assigning(var(A)), to(Value)], Global_Env, New_Global_Env, Result) :-
	find_val(Global_Env, A, Existence),
	(Existence = [[] | _] ->
		eval(Value, Global_Env, _, Eval_Value),
		New_Global_Env = [[A | Eval_Value] | Global_Env],
		Result = 'Assignment.';
		% format('`~w` has already been bound to a value.\n', [A]), % make ret
	New_Global_Env = Global_Env,
	atom_concat('`', A, First_Part),
	atom_concat(First_Part, '` has already been bound.', Error_Message),
	Result = [error, Error_Message]).

% getting a variable's value based on the current global env
eval(var(A), Global_Env, _, Result) :-
	find_val(Global_Env, A, Response),
	(Response = [[], Unbound_Name] ->
		atom_concat('Term `', Unbound_Name, First_Part),
		atom_concat(First_Part, '` is unbound.', Error_Message),
		Result = [error, Error_Message];
	Result = Response).

% applying a function to its argument
eval([calling(A), with(B)], Global_Env, _, Result) :-
	eval(A, Global_Env, _,
		closure(lambda(var(Bound_Term), Body),
		capturing(Captured_Env))),
	eval(B, Global_Env, _, EB),

	% local env is ahead of global env, which enables variable shadowing
	append(Captured_Env, Global_Env, Priority_Env),
	eval(Body, [[Bound_Term | EB] | Priority_Env], _, Result).

% fetching a term from an environment
find_val([], Unbound_Name, [[], Unbound_Name]).
find_val([[Name | Value] | _], Name, Value).
find_val([[_ | _] | Env], Name, Value) :-
	find_val(Env, Name, Value).