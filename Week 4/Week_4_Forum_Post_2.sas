LIBNAME golf "~/DATA103/golf/";
*** DATA and SET Statements ***;

data golf.supplies;
	length mfg $ 6 type $ 8;
	mfg='Crew';
	type='Distance';
	price=8.10;
	output;
	type='Spin';
	price=8.25;
	output;
	type='Titanium';
	price=9.50;
	output;
	mfg='Hi-fly';
	type='X12000';
	price=13.75;
	output;
	type='X22000';
	price=14.60;
	output;
	mfg='White';
	type='Strata';
	price=10.60;
	output;
	type='Aero';
	price=12.30;
	output;
	type='XL';
	price=14.50;
	output;
	type='Flite';
	price=16.20;
	output;
run;

data work.newprice;
	set golf.supplies;
	* input mfg $ type $ price;
	length saletype $ 18;

	if mfg='Crew' then
		do;
			pct=0.75;
			saleprice=price * pct;
			saletype='25% off';
		end;
	else if mfg='Hi-fly' then
		do;
			pct=0.70;
			saleprice=price * pct;
			saletype='30% off';
		end;
	else
		do;
			pct=0.90;
			saleprice=price * pct;
			saletype='10% Storewide Sale';
		end;
	format price saleprice dollar8.2;
run;

proc print;
run;