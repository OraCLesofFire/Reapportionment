

/* addtodistricth(_, _, _, _, _, 1). */
addtodistricth(CITYLIST, DISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, INDEX, SUCCEED) :-
	getleftindex(INDEX, INDEXLEFT),
	addtodistrict(CITYLIST, DISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, INDEXLEFT, SUCCEED),
	getupindex(INDEX, INDEXUP),
	addtodistrict(CITYLIST, DISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, INDEXUP, SUCCEED),
	getrightindex(INDEX, INDEXRIGHT),
	addtodistrict(CITYLIST, DISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, INDEXRIGHT, SUCCEED),
	getdownindex(INDEX, INDEXDOWN),
	addtodistrict(CITYLIST, DISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, INDEXDOWN, SUCCEED).


/* SUCCEED needs to be in helper */
iteratehelper(CITYLIST, NEWDISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, [H], SUCCEED) :-
	addtodistricth(CITYLIST, NEWDISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, H, SUCCEED).

iteratehelper(CITYLIST, NEWDISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, [H|T], SUCCEED) :-
	addtodistricth(CITYLIST, NEWDISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, H, SUCCEED1),
	iteratehelper(CITYLIST, NEWDISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, T, SUCCEED2),
	SUCCEED3 is SUCCEED1 + SUCCEED2,
	bool(SUCCEED3, SUCCEED).

/* this is our proof fact. If we have reached this state, we have succeeded. */
addtodistrict(_, _, _, -1, _, 1).

addtodistrict(CITYLIST, DISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, INDEX, SUCCEED) :-
/* this rule requires that the sum of the index value and district sum be equal to our total sum
 this sends us down a level to a new district index. */
	(
	validindex(INDEX, CITYLIST),
	unusedindex(INDEX),
	/* districtlistnotfull(DISTRICTLIST), I  feel like I don't need this, it's equivalent to unusedindex
	 and totsum is checked immediately after */

	districtsumdouble(CITYLIST, DISTRICTLIST, DISTRICTINDEX, DISTRICTSUM),
	getindexval(CITYLIST, INDEX, INDEXVAL),
	TOTSUM is DISTRICTSUM + INDEXVAL,
	TOTSUM = DISTRICTSIZE,

	districtappend(DISTRICTLIST, DISTRICTINDEX, INDEX, NEWDISTRICTLIST),

	NEWDISTRICTINDEX is DISTRICTINDEX - 1,
	/* Make sure it can actually find a index that it can use. */
	findfirstunusedindex(DISTRICTLIST, CITYLIST, UNUSEDINDEX, [0|0]),
	addtodistrict(CITYLIST, DISTRICTLIST, DISTRICTSIZE, NEWDISTRICTINDEX, UNUSEDINDEX, SUCCEED)
	) ;
	(
	validindex(INDEX, CITYLIST),
	unusedindex(INDEX),

	/* districtlistnotfull(DISTRICTLIST), I  feel like I don't need this, it's equivalent to unusedindex
	 and totsum is checked immediately after */

	districtsumdouble(CITYLIST, DISTRICTLIST, DISTRICTINDEX, DISTRICTSUM),
	getindexval(CITYLIST, INDEX, INDEXVAL),
	TOTSUM is DISTRICTSUM + INDEXVAL,
	TOTSUM < DISTRICTSIZE,

	districtappend(DISTRICTLIST, DISTRICTINDEX, INDEX, NEWDISTRICTLIST),


	getleftindex(INDEX, INDEXLEFT),
	addtodistrict(CITYLIST, NEWDISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, INDEXLEFT, SUCCEED1),
	/* if I want to exit early, here is where I would do it. */
	getupindex(INDEX, INDEXUP),
	addtodistrict(CITYLIST, NEWDISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, INDEXUP, SUCCEED2),
	/* if I want to exit early, here is where I would do it. */
	getrightindex(INDEX, INDEXRIGHT),
	addtodistrict(CITYLIST, NEWDISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, INDEXRIGHT, SUCCEED3),
	/* if I want to exit early, here is where I would do it. */
	getdownindex(INDEX, INDEXDOWN),
	addtodistrict(CITYLIST, NEWDISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, INDEXDOWN, SUCCEED4),
	/* if I want to exit early, here is where I would do it. */
	getdistrict(DISTRICTLIST, DISTRICTINDEX, DISTRICT),


	gethead(DISTRICT, HEAD),
	gettail(DISTRICT, TAIL),

	iteratehelper(CITYLIST, NEWDISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, TAIL, SUCCEED5),

	SUCCEED7 is SUCCEED1 + SUCCEED2 + SUCCEED3 + SUCCEED4 + SUCCEED5,
	bool(SUCCEED5, SUCCEED)
	).

addtodistrict(_, _, _, _, _, 0).
/* this is our fail fact. If we cannot find any other solution, set SUCCEED to 0 and go back.
*/
