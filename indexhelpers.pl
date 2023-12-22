/*
Info on INDEX and it's associated attributes can be found in districthelpers.pl
*/

getleftindex(INDEX, [NEWX|Y]) :-
/* get the index immediately to the "left" of the given index.*/

	gethead(INDEX, X),
	gettail(INDEX, Y),
	NEWX is X - 1.

getrightindex(INDEX, [NEWX|Y]) :- 
/* get the index immediately to the "right" of the given index.*/

	gethead(INDEX, X),
	gettail(INDEX, Y),
	NEWX is X + 1.

getupindex(INDEX, [X|NEWY]) :-
/* get the index immediately "above" the given index.*/

	gethead(INDEX, X),
	gettail(INDEX, Y),
	NEWY is Y + 1.

getdownindex(INDEX, [X|NEWY]) :-
/* get the index immediately "below" the given index.*/

	gethead(INDEX, X),
	gettail(INDEX, Y),
	NEWY is Y - 1.

/* test whether the given index is valid */
validindex([X|Y], [H|_]) :-
/* 
validindex(INDEX, CITYLIST).
This works by grabbing the first list in the citylist, and then calculating its length.
the input index is then tested against the bounds of the citylist-list.
*/
	getlength(H, LEN),
	X < LEN,
	Y < LEN,
	X >= 0,
	Y >= 0.

/* test to ensure that a given index is unused in any existing DISTRICTLIST*/
unusedindex(_, []).
unusedindex(INDEX, [H|T]) :-
/* 
unusedindex(INDEX, DISTRICTLIST)
DISTRICTLIST is a list of lists
we have to iterate through each list in district list 
to ensure that INDEX is not an element of that list.
*/
	notelementof(INDEX,H),
	unusedindex(INDEX, T).

/* 
get the value in CITYLIST associated with an index.
input is of the form (CITYLIST, INDEX, VAL)
the algorithm here is a 3 step algorithm
1st it reduces the Y-Value to 0 by moving through CITYLIST
2nd it reduces the X-Value to 0 by moving through CITYLIST
3rd it picks out the specific value at that index to place into VAL
*/
/* Potential bugs here, indexing and swapping of X/Y coordinates are possibilities*/
getindexval([H|T], [X|Y], VAL) :-
	(
		X =:= 0,
		Y =:= 0, 
		gethead(H, VAL)
	) ;
	(
		gettail(T, TAIL),
		Y1 is Y - 1,
		getindexval([H|TAIL], [X|Y1], VAL)
	) ;
	(
		gettail(H, TAIL),
		X1 is X - 1,
		getindexval([H|TAIL], [X1|Y], VAL)
	).

/* find the first unused index of CITYLIST in DISTRICTLIST*/
findfirstunusedindex(DISTRICTLIST, CITYLIST, UNUSEDINDEX, TESTINDEX) :-
/* 
(DISTRICTLIST, CITYLIST, UNUSEDINDEX, TESTINDEX)
TESTINDEX is started at [0|0], and UNUSEDINDEX is an output value.
we test the TESTINDEX and if it fails, then increment either its X or Y value and try again.
*/
	(
		validindex(TESTINDEX, CITYLIST),
		unusedindex(TESTINDEX, DISTRICTLIST),
		setvalue(UNUSEDINDEX, TESTINDEX)
	) ;
	(
		gethead(TESTINDEX, X),
		gettail(TESTINDEX, Y),
		NEWX is X + 1,
		validindex([NEWX|Y], CITYLIST),
		findfirstunusedindex(DISTRICTLIST, CITYLIST, UNUSEDINDEX, [NEWX|Y])
	) ;
	(
		gethead(TESTINDEX, X),
		gettail(TESTINDEX, Y),
		NEWY is Y + 1,
		validindex([X|NEWY], CITYLIST),
		findfirstunusedindex(DISTRICTLIST, CITYLIST, UNUSEDINDEX, [X|NEWY])
	).