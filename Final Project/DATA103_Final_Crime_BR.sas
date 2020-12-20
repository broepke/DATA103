/*
REFERENCES:
https://resilient.chicago.gov/challenges
https://home.chicagopolice.org/wp-content/uploads/2014/12/2003-Annual-Report.pdf
http://gis.chicagopolice.org/clearmap_crime_sums/crime_types.html
*/
/* Setup: Output results to RTF file. */
ods rtf file='~/DATA103/Week 8/DATA103_Final_Crime_BR.rtf';

proc format;
	value $FBI '01A'='Homicide 1st & 2nd Degree' '02'='Criminal Sexual Assault' 
		'03'='Robbery' '04A'='Aggravated Assault' '04B'='Aggravated Battery' 
		'05'='Burglary' '06'='Larceny' '07'='Motor Vehicle Theft' 
		'08A'='Simple Assault' '08B'='Simple Battery' '09'='Arson' 
		'10'='Forgery & Counterfeiting' '11'='Fraud' '12'='Embezzlement' 
		'13'='Stolen Property' '14'='Vandalism' '15'='Weapons Violation' 
		'16'='Prostitution' '17'='Criminal Sexual Abuse' '18'='Drug Abuse' 
		'19'='Gambling' '20'='Offenses Against Family' '22'='Liquor License' 
		'24'='Disorderly Conduct' '26'='Misc Non-Index Offense';
	value month_name 1='January' 2='February' 3='March' 4='April' 5='May' 6='June' 
		7='July' 8='August' 9='September' 10='October' 11='November' 12='December' 
		other='Invalid';
	value weekday_name 1='Sunday' 2='Monday' 3='Tuesday' 4='Wednesday' 
		5='Thursday' 6='Friday' 7='Saturday';
	value $missfmt ' '='Missing' other='Not Missing';
	value missfmt  .='Missing' other='Not Missing';
	value community 01="Rogers Park" 02="West Ridge" 03="Uptown" 
		04="Lincoln Square" 05="North Center" 06="Lake View" 07="Lincoln Park" 
		08="Near North Side" 09="Edison Park" 10="Norwood Park" 11="Jefferson Park" 
		12="Forest Glen" 13="North Park" 14="Albany Park" 15="Portage Park" 
		16="Irving Park" 17="Dunning" 18="Montclare" 19="Belmont Cragin" 20="Hermosa" 
		21="Avondale" 22="Logan Square" 23="Humboldt Park" 24="West Town" 25="Austin" 
		26="West Garfield Park" 27="East Garfield Park" 28="Near West Side" 
		29="North Lawndale" 30="South Lawndale" 31="Lower West Side" 32="The Loop" 
		33="Near South Side" 34="Armour Square" 35="Douglas" 36="Oakland" 
		37="Fuller Park" 38="Grand Boulevard" 39="Kenwood" 
		40="Washington Park (community area)" 41="Hyde Park" 42="Woodlawn" 
		43="South Shore" 44="Chatham" 45="Avalon Park" 46="South Chicago" 
		47="Burnside" 48="Calumet Heights" 49="Roseland" 50="Pullman" 
		51="South Deering" 52="East Side" 53="West Pullman" 54="Riverdale" 
		55="Hegewisch" 56="Garfield Ridge" 57="Archer Heights" 58="Brighton Park" 
		59="McKinley Park" 60="Bridgeport" 61="New City" 62="West Elsdon" 
		63="Gage Park" 64="Clearing" 65="West Lawn" 66="Chicago Lawn" 
		67="West Englewood" 68="Englewood" 69="Greater Grand Crossing" 70="Ashburn" 
		71="Auburn Gresham" 72="Beverly" 73="Washington Heights" 74="Mount Greenwood" 
		75="Morgan Park" 76="O'Hare" 77="Edgewater";
run;

/* Import Data */
LIBNAME mydata "~/Mydata/";

DATA crime;
	SET mydata.crime;
	drop ID timestamp Updated_On X_Coordinate Y_Coordinate Latitude Longitude beat 
		district ward Location;
	Year=year(date);
	Month=month(date);
	Weekday=weekday(date);
	format fbi_code $FBI.;
	format Month month_name.;
	format Weekday weekday_name.;
	length domestic_code 3;
	domestic_code=ifc(Domestic='true', 1, 0);
RUN;

DATA census;
	SET mydata.census;
	format per_capita_income dollar10.;
RUN;

/*
################################

Preprocessing and Data Cleansing

################################
*/
proc contents data=crime;
run;

proc contents data=census;
run;

/* Check for Missing values */
proc freq data=crime;
	title "Crime: Frequency Tables for Missing Data (Before Cleaning)";
	format _CHAR_ $missfmt.;
	tables _CHAR_ / missing missprint nocum nopercent;
	format _NUMERIC_ missfmt.;
	tables _NUMERIC_ / missing missprint nocum nopercent;
run;

/* Check for Missing values */
proc means data=crime maxdec=2 nmiss min max;
	title "Crime: Summary Statistics (Before Cleaning)";
run;

proc means data=census maxdec=2 nmiss min max;
	title "Census: Summary Statistics (Before Cleaning)";
run;

/* remove nulls */
Data crime;
	Set crime;

	if Community_Area=. then
		delete;

	if Location_Description="" then
		delete;
run;

/* remove nulls */
Data census;
	Set census;

	if Community_Area=. then
		delete;
run;

/* Validate no missing data */
proc freq data=crime;
	title "Crime: Frequency Tables for Missing Data (After Cleaning)";
	format _CHAR_ $missfmt.;
	tables _CHAR_ / missing missprint nocum nopercent;
	format _NUMERIC_ missfmt.;
	tables _NUMERIC_ / missing missprint nocum nopercent;
run;

/* Validate no missing data */
proc means data=crime maxdec=2 nmiss min max;
	title "Crime: Summary Statistics (After Cleaning)";
run;

proc means data=census maxdec=2 nmiss min max;
	title "Census: Summary Statistics (After Cleaning)";
run;

PROC SORT DATA=crime;
	BY Community_Area;
RUN;

PROC SORT DATA=census;
	BY Community_Area;
RUN;

/* Merge the Tables by Community_Area" */
proc sql number;
	create table merged as select * from crime as cr, census as ce where 
		cr.Community_Area=ce.community_area;
quit;

/* NOTE: 95,073 to 95,071 - Two duplicates removed */
proc sort data=merged out=merged nodupkey;
	by _all_;
run;

/* Create a hardship colum that groups by chunks. */
Data merged;
	Set merged;
	length Range $ 8;

	if hardship_index > 75 then
		Idx="4: 75-100";
	else if hardship_index >=51 AND hardship_index <=75 then
		Idx="3: 51-75";
	else if hardship_index >=26 and hardship_index <=50 then
		Idx="2: 26-50";
	else if hardship_index >=1 and hardship_index <=25 then
		Idx="1: 1-25";
run;

/* Inspec for Extreme observations
NOTE: Removed to Simplify the RTF Output
proc univariate data=merged;
run;
*/
/*
################################

EDA (Exploratory Data Analysis)

################################
*/
*1. What’s the overall Arrest Rate?;

proc freq data=merged;
	tables arrest;
	title "Q1: Overall Arrest Rate";
run;

*2. What are the Crime and Arrest rates by offense type?;
ods graphics / width=768px height=768px;

proc sgplot data=merged;
	hbar fbi_code / group=arrest CATEGORYORDER=RESPDESC;
	title "Q2: Crime and Arrest Rates by Offense Type";
	xaxis label="Count";
	yaxis label="FBI Coded Crime";
run;

*3. What are Arrests as a percentage of crimes for the top 20 crimes?;

proc freq data=merged order=freq noprint;
	tables fbi_code / out=primary_type_count(drop=percent);
run;

proc sort data=primary_type_count(obs=20) out=primary_sorted;
	by descending count;
run;

proc sort data=primary_sorted;
	by fbi_code;
Run;

proc sort data=merged;
	by fbi_code;
Run;

DATA top_types_merged;
	MERGE merged (IN=IN_MERGED) primary_sorted(IN=IN_PRIMARY);
	BY fbi_code;

	IF IN_MERGED=1 & IN_PRIMARY=1;
RUN;

proc freq data=top_types_merged order=freq;
	where arrest="true";
	tables fbi_code / nofreq nocum nocol norow;
	title "Q3: Arrest Percentages for Top 20 Crimes";
run;

proc freq data=crime order=freq;
	where fbi_code='18' and arrest="true";
	tables primary_type;
	title "Q3: Top Non-Index Arrests";
run;

*4. What are Crime and Arrest trends over Time (eg: by month, day of week, year, etc)?;

proc sort data=merged;
	by date;
run;

proc sgplot data=merged;
	vbar Weekday / group=arrest;
	title "Q4: Crime and Arrest trends over Time by Weekday";
	xaxis label="Weekday";
	yaxis label="Number of Crimes";
run;

proc sgplot data=merged;
	vbar Month / group=arrest;
	title "Q4: Crime and Arrest trends over Time by Month";
	xaxis label="Month";
	yaxis label="Number of Crimes";
run;

proc sgplot data=merged;
	vbar Year / group=arrest;
	title "Q4: Crime and Arrest trends over Time by Year";
	xaxis label="Year";
	yaxis label="Number of Crimes";
run;

*5. What are Crime trends by location?;

proc freq data=merged order=freq noprint;
	tables Location_Description / out=locations(drop=percent);
run;

proc sort data=locations(obs=20) out=locations_sorted;
	by descending count;
run;

ods graphics / width=768px height=768px;

proc sgplot data=locations_sorted;
	hbar Location_Description / response=count categoryorder=respdesc;
	title "Q5: Crime trends by location";
	footnote "Limited to top 20 based on large long tail of ancillary locations.";
	yaxis label="Location of Crime";
	xaxis label="Count";
run;

footnote;
*6. What are Crime rates by per Capita Income?;

proc univariate data=merged;
	title "Q6: Crime rates by per Capita Income";
	histogram per_capita_income / odstitle=title;
	ods select histogram;
run;

*7. What are Crime Incidents by Hardship Index?;

data community;
	set merged;
	format Community_Area community.;
run;

ods graphics on;
ods select freqplot;

proc freq data=community order=freq;
	tables Idx*fbi_code / crosslist nocum nofreq nocol norow plot(only)=freqplot;
	title "Q7: Crime Incidents by Hardship Index";
run;

*8. Any other questions questions/visualizations you want to explore;
* Domestic Abuse Incidents;

proc sgplot data=community;
	vbar domestic;
	title "Q8: Domestic vs. Non-Domestic Cases";
run;

proc sgplot data=community;
	Where domestic="true";
	hbar fbi_code / group=arrest categoryorder=respdesc;
	title "Q8: Domestic Crime Trends";
run;

data high_income;
	set community;
	where per_capita_income > 84000;
run;

proc sgplot data=high_income;
	hbar fbi_code / group=arrest categoryorder=respdesc;
	title "Q8: High Income Crime Trends";
	footnote "Per Capita Income > $84,000";
run;

footnote;
* Per Capita Income and Murders Per Community;

proc freq data=merged noprint;
	where fbi_code="01A";
	tables community_area / nofreq nocum nocol norow out=murder(drop=percent);
run;

proc sort data=murder;
	by community_area;
run;

proc sort data=census;
	by community_area;
run;

proc sql number;
	create table merged_murders as select * from murder as mu, census as cu where 
		mu.Community_Area=cu.Community_Area;
quit;

data merged_murders;
	set merged_murders;
	keep community_area count per_capita_income hardship_index;
	rename COUNT=Murders;
	format Community_Area community.;
run;

proc sort data=merged_murders;
	by descending per_capita_income;
run;

proc print data=merged_murders;
	title "Q8: Murders Per Area";
run;

/*
################################

Extra Credit: Logistic Model
Extra Credit: Linear Model

################################
*/
proc logistic data=community descending;
	class Domestic Community_Area;
	model Domestic(event='true')=Weekday Community_Area / selection=stepwise expb 
		stb lackfit;
	output out=temp p=new;
	store domestic_logistic;
	title "Logistic Regression Model of Domestic cases and Community Areas";
run;

/* Linear Model  */
PROC CORR DATA=census;
	WITH hardship_index;
	TITLE 'Correlation for Hardship Index';
RUN;

PROC REG data=census;
	MODEL hardship_index=percent_aged_16_unemployed 
		percent_aged_25_without_high_sch percent_aged_under_18_or_over_64 
		percent_households_below_poverty;
	TITLE "Multiple Regression to Calculate Hardship Index";
	RUN;
QUIT;

/* Close out files*/
ods rtf close;