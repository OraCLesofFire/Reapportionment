/* 
basic test for boolean values.
Anything greater than 1 is considered to be true
*/
bool(VAL, OUT) :-
	VAL > 0,
	OUT is 1.
bool(VAL, OUT) :-
	VAL =:= 0,
	OUT is 0.

/* simple rule that can be used to force an unknown element to be equal to a value.*/
setvalue(X,X).

/* basic append rule*/
append([],L,L).
append([H|L1],L2,[H|L3]) :- append(L1,L2,L3).

/* get the length of the given list. */
getlength([], 0).
getlength([_|T], LEN1) :-
	getlength(T, LEN),
	LEN1 is LEN + 1.

/* 
test to ensure I does not exist in a district list
if INDEX does not exist in LIST then the rule succeeds
*/
notelementof(_, []).
notelementof(I, [H|T]) :-
/* notelementof(INDEX, LIST)*/
	I \= H,
	notelementof(I, T). 