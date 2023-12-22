/* 
get the sum of values in a district
in order to do this we need to calculate the value of each index in the districtlist
we first pull out the correct district to sum
then we find the value associated with every index from the district in CITYLIST
then we sum those values 
*/
districtsumdouble(CITYLIST, DISTRICTLIST, DISTRICTINDEX, SUM) :-
	getdistrict(DISTRICTLIST, DISTRICTINDEX, DISTRICT),
	getdistrictsum(CITYLIST, DISTRICT, SUM).

/* calculate the sum of every index in a given district*/
getdistrictsum(_, [], 0).
getdistrictsum(CITYLIST, [H|T], SUM) :-
/* this assumes that the second value is a District (list of indices)
grabs the value of the initial index, than sums it with a recursive call*/
	getindexval(CITYLIST, [H], VAL),
	getdistrictsum(CITYLIST, T, VAL1),
	SUM is VAL + VAL1.




/* 
append a new index into a district.
1. find the district to append to.
2. add the index to the new district
3. get the list of all districts that were before and after the district
4. append the lists of districts back together
*/
districtappend(DISTRICTLIST, DISTRICTINDEX, INDEX, NEWDISTRICTLIST) :-
	getdistrict(DISTRICTLIST, DISTRICTINDEX, DISTRICT),
	append(DISTRICT, INDEX, NEWDISTRICT),
	getprevdistrict(DISTRICTLIST, DISTRICTINDEX, PREVDISTRICT),
	getpostdistrict(DISTRICTLIST, DISTRICTINDEX, POSTDISTRICT),
	append(PREVDISTRICT, NEWDISTRICT, D1),
	append(D1, POSTDISTRICT, NEWDISTRICTLIST).

/* this extracts a specific DISTRICT from DISTRICTLIST*/
getdistrict([H|_], 0, H).
getdistrict([_|T], DISTRICTINDEX, DISTRICT) :-
/* (DISTRICTLIST, DISTRICTINDEX, DISTRICT)*/
	I = DISTRICTINDEX - 1,
	getdistrict(T, I, DISTRICT).

/* extract all DISTRICT from DISTRICTLIST where DISTRICTINDEX > 0*/
getprevdistrict([_|_], 0, []).
getprevdistrict([H|T], DISTRICTINDEX, DISTRICTLIST) :-
/* recursively append the first element to all future elements. at index 0 we return an empty list*/
	I = DISTRICTINDEX - 1,
	getprevdistrict(T, I, DISTRICTLIST1),
	append(H, DISTRICTLIST1, DISTRICTLIST).

/* extract all DISTRICT from DISTRICTLIST where DISTRICTINDEX < 0*/
getpostdistrict([], _, []).
getpostdistrict([_|T], DISTRICTINDEX, T) :-
/* in the case of our index being 0, return the tail of our DISTRICTLIST*/
	DISTRICTINDEX =:= 0.
getpostdistrict([_|T], DISTRICTINDEX, DISTRICTLIST) :-
/* otherwise decrement the index and call again on the tail of our DISTRICTLIST*/
	I = DISTRICTINDEX - 1,
	getpostdistrict(T, I, DISTRICTLIST).