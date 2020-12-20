options nodate pageno=1 linesize=80 pagesize=64;

data cake;
	input LastName $ 1-12 Age 13-14 PresentScore 16-17 TasteScore 19-20 
		Flavor $ 23-32 Layers 34;
	datalines;
Orlando     27 93 80  Vanilla    1 
Ramey       32 84 72  Rum        2 
Goldston    46 68 75  Vanilla    1 
Roe         38 79 73  Vanilla    2 
Larsen      23 77 84  Chocolate  . 
Davis       51 86 91  Spice      3 
Strickland  19 82 79  Chocolate  1 
Nguyen      57 77 84  Vanilla    . 
Hildenbrand 33 81 83  Chocolate  1 
Byron       62 72 87  Vanilla    2 
Sanders     26 56 79  Chocolate  1 
Jaeger      43 66 74             1 
Davis       28 69 75  Chocolate  2 
Conrad      69 85 94  Vanilla    1 
Walters     55 67 72  Chocolate  2 
Rossburger  28 78 81  Spice      2 
Matthew     42 81 92  Chocolate  2 
Becker      36 62 83  Spice      2 
Anderson    27 87 85  Chocolate  1 
Merritt     62 73 84  Chocolate  1
;
run;

proc format;
	value $flvrfmt 'Chocolate'='Chocolate' 'Vanilla'='Vanilla' 'Rum', 
		'Spice'='Other Flavor';
	value agefmt (multilabel) 15 - 29='below 30 years' 30 - 50='between 30 and 50' 
		51 - high='over 50 years' 15 - 19='15 to 19' 20 - 25='20 to 25' 
		25 - 39='25 to 39' 40 - 55='40 to 55' 56 - high='56 and above';
run;

/*
proc sort data=cake out=cake;
by flavor;
run;
*/
/*Type code for question E*/
proc means data=cake fw=8 maxdec=4 n min max std alpha=0.1 clm nonobs;
	var TasteScore;

	/* Type code to compute statistics class flavor*/
	class flavor / order=freq ascending;

	/* Type code to add format here*/
	format Flavor $flvrfmt.;
	format Age agefmt.;
	title 'Taste Score for Cake Flavors and Participant''s Age';
	output out=Mymeansoutput;
run;

/*Type code for question E*/
proc means data=cake fw=8 maxdec=4 n min max std alpha=0.1 clm nonobs;
	var TasteScore;

	/* Type code to compute statistics class age*/
	class flavor age / mlf order=fmt;
	types flavor*age;

	/* Type code to add format here*/
	format Flavor $flvrfmt.;
	format Age agefmt.;
	title 'Taste Score for Cake Flavors and Participant''s Age';
	output out=Mymeansoutput;
run;