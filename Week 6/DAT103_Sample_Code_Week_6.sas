/**** GCHART Procedure ***/
proc print data=sashelp.class;
run;

*** bar chart/histogram **;
proc gchart data=sashelp.class;
  vbar age / type=percent;
  run;
quit;

*** discreate factors ***;
proc gchart data=sashelp.class;
  vbar age / discrete type=percent;
  run;
quit;

*** response variable ***;
proc gchart data=sashelp.class;
   vbar age / discrete type=mean sumvar=height mean;
   run; 
quit;

*** HBAR and using GROUP ***;
proc gchart data=sashelp.class;
   hbar age / discrete type=mean sumvar=height mean
   group=sex;
   run; 
quit;

** Using SUBGROUP **;
proc gchart data=sashelp.class;
   vbar age / discrete type=percent subgroup=sex;
   run; 
quit;


*** Labels and Titles ***;
proc gchart data=sashelp.class;
	title1 'Increase of Height with Age';
	title2 '(Average Height in Inches)';
	format height 5.;
	label age= 'Age to Nearest Year' height='Height';
	vbar age / discrete type=mean sumvar=height ;
	run;
quit;

*** RUN-GROUP PROCESSING ***;
proc gchart data=sashelp.class;
	title1 'Increase of Height with Age';
	title2 '(Average Height in Inches)';
	format height weight 5.;
	label age='Age to Nearest Year' height='Height' weight='Weight';
	vbar age / discrete type=mean mean 
	       sumvar=height;
	run;
	
	title1 'Increase of Weight with Age';
	title2 '(Average Weight in Pounds)';
	vbar age / discrete type=mean mean sumvar=weight;
	run;
quit;

*** BY-GROUP PROCESSING ***;
proc sort data=sashelp.class out=class;
  by sex;
run;

proc gchart data=class;
	vbar age / discrete type=freq;
	by sex;
	run;
quit;

*** WHERE PROCESSING ***;
proc gchart data=sashelp.class;
	title1 'Frequency of Males by Age';
	where sex = 'M';
	vbar age / discrete type=freq;
	run; 
quit; 


/****  GPLOT procedure ***/

proc gplot data=sashelp.class;
	title 'Scatter Plot of Height and Weight';
	plot height* weight;
	run;
quit;

*** SUBGROUPS ***;
proc gplot data=sashelp.class;
	title 'Scatter Plot of Height and Weight';
	plot height* weight = sex;
	run;
quit;

*** PLOTS WITH INTERPOLATIONS ***;
proc gplot data=sashelp.class;
	title1 'Linear Regression of Height and Weight';
	title2 '(with 95% Confidence Limits)';
	symbol ci=red cv=blue co=gray value=dot interpol=rlclm95 ;
	proc gplot data=sashelp.class;
	plot height*weight / regeqn;
	run;
quit;