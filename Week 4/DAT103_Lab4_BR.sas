Data task1_2_data;
	Input ID Q1-Q3;
	datalines;
	85 1 2 3  
	90 3 4 6  
	95 5 5 6  
	100 6 6 4  
	105 5 5 6  
	110 6 6 5  
	;
run;

/* Write code using IF statement to exclude
IDs whose values are greater than 100.  */
Data task1_if;
	Set task1_2_data;

	if ID <=100;
run;

proc print;
run;

/* This can also be done using the IF-THEN DELETE statement. */
Data task1_if_delete;
	Set task1_2_data;

	if ID > 100 then
		delete;
run;

proc print;
run;

/* If value of ID is less than or equal to 100 set
"Old" tag otherwise set "New" tag. */
Data task2;
	Set task1_2_data;

	if ID <=100 then
		TAB="Old";
	else
		TAB="New";
Run;

proc print;
run;

/*
If ID is less than 75 then TAG = "Old"
If ID is greater than or equal to 75 and less than 100 then TAG = "New"
If ID is greater than or equal to 100 then TAG = "Unchecked"
*/
Data Task3_data;
	Input ID Q1-Q3;
	datalines;
70 1 2 3  
45 1 2 3  
85 1 2 3  
25 1 2 3  
90 3 4 6  
95 5 5 6  
100 6 6 4  
105 5 5 6  
110 6 6 5  
;

Data task3;
	Set task3_data;
	length TAB $ 9;

	if ID < 75 then
		TAB="Old";
	else if ID >=75 AND ID < 100 then
		TAB="New";
	else
		TAB="Unchecked";
run;

proc print;
run;

/* generate an analysis for Q1 including only responses 
that are valid (nonmissing) and less than 3 */
Data task4_data;
	Input ID Q1-Q3;
	datalines;
	85 1 2 3
	90 . 4 6
	95 2 5 6
	100 6 6 4
	105 . 5 6
	110 6 6 5
	;
run;

Data task4;
	set task4_data;
	if Q1 < 3 and not missing(q1);
run;

proc print;
run;