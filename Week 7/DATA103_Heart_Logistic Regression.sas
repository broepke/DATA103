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

proc format;
	value $gender 'F'='Female' 'M'='Male' 'm'='Male';
run;

data heart_clean;
	set heart;
	format Sex $gender.;
run;

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

/* ############################### 

       LOGISTIC REGRESSION

############################### */

/* Splitting the dataset into traning and validation using 70:30 ratio */
proc sort data=heart_clean out=train_sorted;
	by Status;
run;

proc surveyselect data=train_sorted out=train_survey outall samprate=0.7 
		seed=12345;
	strata Status;
run;

/* Generating frequency table */
proc freq data=train_survey;
	tables Selected*Status;
run;

/* Creating Logistic regression model */
proc logistic data=train_survey descending;
	where Selected=1;
	class Status Sex Chol_Status BP_Status Weight_Status Smoking_Status;
	model Status(event='Dead')=Sex Chol_Status BP_Status Weight_Status 
		Smoking_Status AgeCHDdiag Height Weight AgeAtStart MRW Smoking Cholesterol 
		Diastolic Systolic / selection=stepwise expb stb lackfit;
	output out=temp p=new;
	store heart_logistic;
run;

/* Simplifying the Logistic regression model */
proc logistic data=train_survey descending;
	where Selected=1;
	class Status Sex;
	model Status(event='Dead')=Sex AgeCHDdiag AgeAtStart Smoking Systolic / 
		selection=stepwise expb stb lackfit;
	output out=temp p=new;
	store heart_logistic;
run;

data test;
	set train_survey;
	where Selected=0;
run;

/* Testing with our model */
proc plm source=heart_logistic;
	score data=test out=test_scored predicted=p / ilink;
run;

proc print data=test_scored;
	where p > .7 and Status="Alive";
run;