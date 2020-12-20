/* Setup: Output results to RTF file. */
ods rtf file='~/DATA103/Week 5/DATA103_HeartAnalysis_BR.rtf';

/*
1. Import the ​heart.csv ​dataset to your SAS environment using the
Data Step and INFILE statements, with the following columns. ​
Note​: use ​length​ to specify the column lengths as shown below.
The dataset has missing values so use the appropriate INFILE options.
*/
data heart;
	length Status $ 5 DeathCause $ 26 AgeCHDdiag 8 Sex $ 6 AgeAtStart 8 Height 8 
		Weight 8 Diastolic 8 Systolic 8 MRW 8 Smoking 8 AgeAtDeath 8 Cholesterol 8 
		Chol_Status $ 10 BP_Status $ 7 Weight_Status $ 11 Smoking_Status $ 17;
	infile '~/DATA103/Week 5/heart.csv' delimiter=',' firstobs=1 dsd;
	input Status $
	DeathCause $
	AgeCHDdiag Sex $
	AgeAtStart Height Weight Diastolic Systolic MRW Smoking AgeAtDeath 
		Cholesterol Chol_Status $
	BP_Status $
	Weight_Status $
	Smoking_Status $;
	label DeathCause="Cause of Death" AgeCHDdiag="Age CHD Diagnosed" 
		AgeAtStart="Age at Start" MRW="Metropolitan Relative Weight" 
		AgeAtDeath="Age at Death" Chol_Status="Cholesterol Status" 
		BP_Status="Blood Pressure Status" Weight_Status="Weight Status" 
		Smoking_Status="Smoking Status";
run;

/*
2. Display the contents of the dataset. What is the data set’s shape
(eg: number of columns and rows and column types?)
You can capture a screenshot with this information.
*/
proc contents data=heart;
run;

/*
3. Create a report using PRINT which shows the first 10 observations.
Include a title: ​The First 10 Observations Out of <n>​ replacing n
with the actual number of rows
*/
data _null_;
	if 0 then
		set heart nobs=n;
	call symputx('nobs', n);
	stop;
run;

proc print data=work.heart (obs=10);
	title 'The First 10 Observations Out of ' &nobs;
run;

/***  Validating Data  ***/
/*
Are all values valid for categorical data?​ ​Use ​PROC FREQ​ to list the
unique values for char values. Simplify the output by using the
NOCUM (no cumulative statistics) and NOPERCENT (no percentages)
TABLES options. Include a title:​ Frequency Counts for Selected
Character Variables​. Are there missing or invalid values?
Show screenshots of each variable’s frequency tables,
annotating what it tells you.
*/
proc freq data=heart;
	tables Status DeathCause Sex Chol_Status BP_Status Weight_Status 
		Smoking_Status / NOCUM NOPERCENT;
	title 'Frequency Counts for Selected Character Variables';
run;

/*
Check for outliers and missing values in numeric data​.
Use PROC MEANS with options to show the number of missing
and nonmissing values as well as the min/max values.
Describe your observations.
*/
proc means data=heart maxdec=2 nmiss min max;
	title "Summary Statistics (Before Cleaning)";
run;

/*** Cleaning Data ***/
/*
Create custom formats for use with Sex and use it in a new
clean dataset (eg: heart_clean) For example: $GENDER for use with Sex.
Use only labels ‘Female’ and ‘Male’
*/
proc format;
	value $gender 'F'='Female' 'M'='Male' 'm'='Male';
run;

data heart_clean;
	set heart;
	format Sex $gender.;
run;

proc freq data=heart_clean;
	tables Sex / NOCUM NOPERCENT;
	title 'Frequency Counts for Sex (After Cleaning)';
run;

/*
Determine the missing values for each variable and decide if any
of these observations should be deleted. Note: a missing value
doesn’t necessarily mean invalid data, for example: there are a
large number of missing values for AgeAtDeath, corresponding to
patients that are still alive. How many observations are
left after deletes? (hint: Log output)
*/
Data heart_clean;
	Set heart_clean;

	if weight=. then
		delete;

	if height=. then
		delete;

	if MRW=. then
		delete;

	if Smoking=. then
		delete;

	if Cholesterol=. then
		delete;
run;

* AFTER cleaning missing values *;

proc means data=heart_clean maxdec=2 nmiss min max;
	title "Summary Statistics (After Cleaning)";
run;

proc freq data=heart_clean;
	tables Status DeathCause Sex Chol_Status BP_Status Weight_Status 
		Smoking_Status / NOCUM NOPERCENT;
	title 'Frequency Counts for Selected Character Variables (After Cleaning)';
run;

data _null_;
	if 0 then
		set heart_clean nobs=n;
	call symputx('nobs', n);
	stop;
run;

proc print data=work.heart_clean (obs=10);
	title 'Cleanded Dataset First 10 Obs Out of ' &nobs;
run;

/*
Add a new numeric variable called ​Status_Num​ which is the
binary representation of status where ‘Dead’ is set to 0 while ‘Alive’
is set to 1. (hint: use ​ifc​ )
*/
data heart_clean;
	set heart_clean;
	length ​Status_Num​ 3;
	​Status_Num​=ifc(Status='Dead', 0, 1);
run;

/* Print contents as well as the first 10 observations of the
cleaned data set */
proc print data=work.heart_clean (obs=10);
	title 'The First 10 Observations Out of ' &nobs;
run;

/*** Analysis ***/
/*
Create a two-way, crosstabulation table.
Use options NOROW NOCOL and include a title.
*/
proc freq data=heart_clean;
	tables Sex * Status / norow nocol;
	title "Two-Way Crosstab for Sex and Status (Alive/Dead)";
run;

/*
Use PROC UNIVARIATE to show a histogram of death status by gender.
You will need to use variable ​Status_Num​.
*/
proc univariate data=heart_clean;
	class Sex;
	title "Distribution of men and women by Status (Dead/Alive)";
	histogram ​Status_Num​ / odstitle=title endpoints = 0 to 1 by 1 nrows=1 ncols=2;
	ods select histogram;
run;

/*
Use PROC MEANS to show descriptive statistics N, MIN, MAX, MEAN,
Standard Deviation, and Variance for variables:
sex status weight diastolic systolic smoking cholesterol.
Include up to 2 decimal places.
*/
proc means data=heart_clean maxdec=2 n min max mean stddev var;
	vars Weight Diastolic Systolic Smoking Cholesterol;
	class Sex Status;
	title "Summary Statistics";
run;

/*
Identify 2 or more additional questions to analysis, providing
corresponding code and visuals. For example:
a. How does smoking impact status?
b. What are the leading causes of death ?
*/
* What are the top causes of death for men and women;

proc freq data=heart_clean;
	where Status="Dead";
	tables DeathCause * Sex / nofreq norow nocol nocum;
	title "Top Causes of Death by Gender";
run;

* Do people who smoke less live longer?;

proc sgplot data=heart_clean;
	where Status="Dead";
	density AgeAtDeath / type=kernel group=Smoking_Status;
	title "Distribution Ages at Death by Level of Smoking";
run;

proc means data=heart_clean maxdec=2 mean;
	where Status = "Dead";
	vars AgeAtDeath;
	class Smoking_Status;
	title "Mean Age of Death by Smoking Status";
run;

* Obesity and Death Cause;

proc freq data=heart_clean;
	where Status="Dead";
	tables DeathCause * Weight_Status / nofreq norow nocol nocum;
	title "Crosstab of Cause of Death and Weight";
run;

/* Close out files*/
ods rtf close;