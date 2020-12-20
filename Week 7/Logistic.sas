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

/* Logistic Regression */

proc surveyselect data=heart_clean out=MB n=100 outall;
run;

proc surveyselect data=MB out=XV (drop=SELECTED) n=100;
	where SELECTED=0;
run;

data MB (drop=SELECTED);
	set MB;
	where SELECTED=1;
run;

proc reg data=MB outest=regModel;
	P_Cholesterol : model Cholesterol=Weight Height;
	run;
quit;

proc score data=XV score=regModel type=parms predict out=XV;
	var Weight Height;
run;

proc logistic data=MB outmodel=logitModel;
	model Status(Event='Dead')=Weight Height;
run;

proc tpspline data=MB;
	model Cholesterol=(Height Weight);
	score data=XV out=XV;
run;

proc logistic inmodel=logitModel;
	score data=XV out=XV;
run;

ods graphics on;

proc logistic inmodel=logitModel;
	score data=XV out=XV fitstat;
run;

%let true = Cholesterol;
%let pred = P_Cholesterol;
%let dataset = XV;

proc sql;


proc logistic data=MB rocoptions(id=cutpoint);
	model Status(Event='Dead')=Weight Height;
	score data=XV out=XV outroc=rocdata;
run;

ods graphics off;