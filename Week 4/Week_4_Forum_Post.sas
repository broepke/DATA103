/* Fixed Version */
data grades;
	input name $ gpa;

	if gpa>=3.5 then
		gpagroup="Excellent Grades";

	if gpa>=3.0 then
		gpagroup="Good";

	if gpa >=2.5 then
		gpagroup="Satisfactory";
	datalines;
	Ann 3.7
	Bart 2.9
	Cecil 3.5
	Denise 4.0
	Emily 2.5
	Frank 3.1
	;
run;

PROC PRINT data=grades;
RUN;

/* Fixed Version */
data grades;
	input name $ gpa;

	if gpa >=3.5 then
		gpagroup="Excellent Grades";
	else if gpa >=3.0 then
		gpagroup="Good";
	else if gpa >=2.5 then
		gpagroup = "Satisfactory";
	else
		gpagroup="Fail";
	datalines;
	Ann 3.7
	Bart 2.9
	Cecil 3.5
	Denise 4.0
	Emily 2.4
	Frank 3.1
	;
run;

PROC PRINT data=grades;
RUN;