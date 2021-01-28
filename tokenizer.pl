delimiter('=').
delimiter('\\').
delimiter('.').
delimiter('(').
delimiter(')').

lex([], Buffer, [Buffer]).

lex([Char | Chars], Buffer, Tokens) :-
	delimiter(Char) ->
		lex(Chars, '', Tail_Tokens),
		Tokens = [Buffer, Char | Tail_Tokens];

	Char = ' ' ->
		lex(Chars, '', Tail_Tokens),
		Tokens = [Buffer | Tail_Tokens];

	atom_concat(Buffer, Char, New_Buffer),
	lex(Chars, New_Buffer, Tokens).

filter_empty_blank([], []).
filter_empty_blank([Head | Tail], Result) :-
	filter_empty_blank(Tail, Tail_Result),
	((Head = []; Head = '') ->
		Result = Tail_Result;
		Result = [Head | Tail_Result]).

tokenize(Chars, Tokens) :-
	lex(Chars, '', Dirty_Tokens),
	filter_empty_blank(Dirty_Tokens, Tokens).