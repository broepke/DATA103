/* Setting the library path */
libname PRAC "~/DATA103/Week 7";

/* Importing dataset using proc import */
proc import datafile="~/DATA103/Week 7/train.csv" out=work.train dbms=CSV;
run;

/* Checking the contents of the data*/
proc contents data=work.train;
	title "Survived vs Gender";
run;

/* Checking the missing value and Statistics of the dataset */
proc means data=work.train N Nmiss mean std min P1 P5 P10 P25 P50 P75 P90 P95 
		P99 max;
run;

/* Checking the frequency of the Target Variable Survived */
proc freq data=work.train;
	table Survived;
run;

proc freq data=work.train nlevels;
	title "Frequency tables for categorical variables in the training set";
	tables Survived;
	tables Sex;
	tables Pclass;
	tables SibSp;
	tables Parch;
	tables Embarked;
	tables Cabin;
run;

proc sort data=work.train out=sorted;
	by Pclass descending Age;
run;

title "Box Plot for Age vs Class";

proc boxplot data=sorted;
	plot Age*Pclass;
run;

data work.train2;
	set work.train;

	if age="." and Pclass=1 then
		age=37;
	else if age="." and Pclass=2 then
		age=29;
	else if age="." and Pclass=3 then
		age=24;
run;

/* Splitting the dataset into traning and validation using 70:30 ratio */
proc sort data=work.train out=train_sorted;
	by Survived;
run;

proc surveyselect data=train_sorted out=train_survey outall samprate=0.7 
		seed=12345;
	strata Survived;
run;

/* Generating frequency table */
proc freq data=train_survey;
	tables Selected*Survived;
run;

/* This is where things actually start to matter - the above was all cleanup */
/* Creating Logistic regression model */
proc logistic data=train_survey descending;
	where Selected=1;
	class Embarked Parch Pclass Sex SibSp Survived;
	model Survived(event='1')=Age Fare Embarked Parch Pclass Sex SibSp / 
		selection=stepwise expb stb lackfit;
	output out=temp p=new;
	store titanic_logistic;
run;

data test;
	set train_survey;
	where Selected=0;
run;

/* Testing with our model titanic_logisitic */
proc plm source=titanic_logistic;
	score data=test out=test_scored predicted=p / ilink;
run;

proc print data=test_scored;
	where p > .5;
run;