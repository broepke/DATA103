ods pdf file='~/DATA103/Week 6/pdf.pdf';
ods html close;
ods pdf;
goptions reset=all border;

proc gchart data=sashelp.class;
	title1 'Increase of Height with Age';
	title2 '(Average Height in Inches)';
	format height 5.;
	label age= 'Age to Nearest Year' height='Height';
	vbar age / discrete type=mean sumvar=height ;
	run;
quit;
ods pdf close;