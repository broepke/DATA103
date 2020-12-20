*************************************************************************************
DATA103 Session2
Tips: highlight the code that you want to run and click icon 'Run' to see the result.
*************************************************************************************;
/*Requirement: create folder 'golf' by right click on DATA 103) > New > Folder */
LIBNAME golf "~/DATA103/golf/";

*** DATA and SET Statements ***;
data golf.supplies;
   length mfg $ 6 type $ 8;
   mfg='Crew'; type='Distance'; price=8.10;   output;
               type='Spin';     price=8.25;    output;
               type='Titanium'; price=9.50;   output;
   mfg='Hi-fly'; type='X12000'; price=13.75;  output;
                 type='X22000'; price=14.60;  output;
   mfg='White'; type='Strata';  price=10.60;  output;
                type='Aero';    price=12.30;  output;
                type='XL';      price=14.50;  output;
                type='Flite';   price=16.20;  output;
run;
data work.newprice;
   set golf.supplies;
   saleprice=price*0.75;
run;
options ls=64;
proc contents;
run;
proc print;
run;

*** DROP/KEEP Statement ***;
data work.newprice;
   set golf.supplies;
   saleprice = price * 0.75;
   drop mfg price;
run;
proc print;
run;

*** FORMAT and LABEL Statements ***;
data work.newprice;
   set golf.supplies;
   saleprice = price * 0.75;
   drop mfg price;
   format saleprice dollar18.2;
   label type='Type of Ball'
         saleprice='Sale Price';
run;
proc contents data=work.newprice;
run;
options ls=64;
proc print data=work.newprice label;
run;

*** Implied Output ***;
data work.scores;
   input name $ test1 test2;
   datalines;
Kent 73 79
Mary 89 94
Sally 75 86
Thomas 92 95
;
run;
data work.total;
   set work.scores;
   total=test1+test2;
run;
proc print;
run;

*** Explicit Output ***;
data work.rotate;
   set work.scores;
   test=test1;
   output;
   test=test2;
   *output;
   drop test1 test2;
run;
proc print;
run;

*** Multiple Data Sets ***;
data work.first work.second;
   set work.scores;
   test=test1;
   output work.first;
   test=test2;
   output work.second;
   drop test1 test2;
run;
proc print data=work.first;
run;
proc print data=work.second;
run;

data work.total work.first work.second;
   set work.scores;
   total=test1+test2;
   output;
   drop test1 test2;
run;
proc print data=work.total;
run;
proc print data=work.first;
run;
proc print data=work.second;
run;

data work.total work.first work.second;
   set work.scores;
   total=test1+test2;
   output work.total;
   test=test1;
   output work.first;
   test=test2;
   output work.second;
   drop test1 test2;
run;
proc print data=work.total;
run;
proc print data=work.first;
run;
proc print data=work.second;
run;

*** DROP=/KEEP= Options ***;
data work.total(keep=name total test1 test2) 
     work.first(drop=test1 test2) 
     work.second(keep=name total test);
   set work.scores;
   total=test1+test2;
   output work.total;
   test=test1;
   output work.first;
   test=test2;
   output work.second;
run;
proc print data=work.total;
run;
proc print data=work.first;
run;
proc print data=work.second;
run;

*** IF THEN OUTPUT Statement ***;
data female male all(keep=name weight height);
   set sashelp.class;
   if sex='F' then output female all;
   else if sex='M' then output male all;
run;
proc print data=female;
run;
proc print data=male;
run;
proc print data=all;
run;


*** FIRSTOBS= and OBS= Options ***;
data work.all;
   set sashelp.retail;
run;
proc print;
run;
data work.ten;
   set sashelp.retail(obs=10);
run;
proc print;
run;
data work.portion;
   set sashelp.retail(firstobs=5 obs=10);
run;
proc print;
run;

data shoes(firstobs=101 obs=200);
   set sashelp.shoes;
run;
data shoes;
   set sashelp.shoes(firstobs=101 obs=200);
run;
proc print data=sashelp.shoes(firstobs=101 obs=200);
run;

*** Operators ***;
data names;
   input name $;
   datalines;
Mark
Marcia
Mickey
Matthew
Michael
;
run;
data new;
   set names;
   where name like 'M__k%';
run;
proc print;
run;

*** Subsetting Statements ***;
data golf.supplies;
   length mfg $ 6 type $ 8;
   mfg='Crew'; type='Distance'; price=8.10;   output;
               type='Spin';     price=8.25;    output;
               type='Titanium'; price=9.50;   output;
   mfg='Hi-fly'; type='X12000'; price=13.75;  output;
                 type='X22000'; price=14.60;  output;
   mfg='White'; type='Strata';  price=10.60;  output;
                type='Aero';    price=12.30;  output;
                type='XL';      price=14.50;  output;
                type='Flite';   price=16.20;  output;
run;

data work.newprice;
   set golf.supplies;
   saleprice=price*0.75;
   if not (saleprice > 10) then delete;
   *if saleprice > 10;
   *where saleprice > 10;
run;
proc print;
run;

data work.newprice;
   set golf.supplies;
   where mfg='White';
   saleprice=price*0.75;
   if saleprice > 10;
run;
proc print;
run;