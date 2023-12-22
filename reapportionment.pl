/*
The reapportionment problem can be simply stated as:
"Can a 2D array (CITYLIST) be broken down into N contiguous sections (DISTRICT) of equal value"
The inputs are simple then:
	- CITYLIST
		- A list of lists (each containing an integer)
	- DISTRICT
		- this is our N from above, the number of contiguous sections to break out city down into.

My solution algorithm follows a simple premise. 
	- Recursively attempt to create districts of equivalent value.
	- If we can succeed in creating all N districts, then the problem has been solved.

	- creating districts is done using an abstract shape algorithm which works as such:
		- Start at an unused index.
		- recursively add the indices Left - Up - Right - Down (in that order) into our DISTRICTLIST 
			(assuming they meet the valid criteria).
		- then iterate over every index in our existing DISTRICTLIST
			- 	recursively add the indices to the Left - Up - Right - Down of our current index (in that order)
				 into our DISTRICTLIST 	(assuming they meet the valid criteria).
		- if by this point we have failed to achieve a solution at any time, then our program returns a failure to prove.
		- if by this point we have succeeded to achieve a solution at any time, then our program returns a success.
*/

/* 
In the reapportionment problem we 4 different types of lists.
1. CITYLIST
	- this is a list containing lists. Effectively a 2D array.
	- the 2D array is square (same # of rows and cols)
	- each element in each list contains a single integer.
	- this list is passed into the program at the start.
	- this list never changes.
2. DISTRICTLIST
	- this is a list containing every district I need to create.
	- each element of the list is a district.
	- this list is created by the program from CITYLIST, however once passed into the main algorithm
		the number of elements of DISTRICTLIST never changes.
3. DISTRICT
	- this is a list containing indices.
	- the length is variable, and depends on the values associated with each index in CITYLIST.
4. INDEX
	- this is a list containing a X-Value and Y-Value.
	- Each index is important only in that it allows you to point to values within CITYLIST.
*/

/* the following are helper rules for our abstract shape algorithm. */
:- include(basichelpers).
:- include(indexhelpers).
:- include(districthelpers).

/* the abstract shape algorithm itself. */
:- include(abstractshape).

succeed(1).
reapportionment(CITYLIST,DISTRICTS) :-

	/* simple test to ensure the input can be broken into N DISTRICTs of equivalent value*/
	doublearraysum(CITYLIST, CITYSIZE),
	valid is CITYSIZE mod DISTRICTS,
	valid =:= 0,

	/* simple test to ensure that the max size element in CITYLIST is less than the max size of a district*/
	DISTRICTSIZE is CITYSIZE / DISTRICTS,
	maxelementdouble(CITYLIST, MAX),
	MAX < DISTRICTSIZE,

	/* create out DISTRICTLIST, set our DISTRICT INDEX to the "last" district in our DISTRICTLIST 
	(this causes us to start using the last district, rather than the first, and work toward the front)*/
	createdistrictlist(DISTRICTS, DISTRICTLIST),
	DISTRICTINDEX is DISTRICTS - 1,

	/* initiate the abstract shape algorithm by adding (0,0) to the "last" district.*/
	addtodistrict(CITYLIST, DISTRICTLIST, DISTRICTSIZE, DISTRICTINDEX, [0|0], SUCCEED),

	/* 
	our success/fail condition is based on a boolean value.
	if SUCCEED gets 1 at any point during the algorithm, then we succeed, otherwise we fail
	the algorithm ensures any 1's get carried through.
	*/
	succeed(SUCCEED).



/* test by building block. make a subroutine that finds a contiguous region. */