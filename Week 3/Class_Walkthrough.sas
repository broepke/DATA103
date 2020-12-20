LIBNAME mydata "~/Mydata/"; 

** export to csv **;
proc export data=mydata.auto
outfile='~/Mydata/auto.csv' 
dbms=csv
replace;
run;

** reading a datafile via list input **;
DATA auto2 (keep=make mpg price);
  INFILE  '~/Mydata/auto.csv'
     DELIMITER = ','
     FIRSTOBS = 2
  ;
  INPUT make $ price mpg;
RUN;
PROC PRINT data = auto2 (obs=5);
RUN;

DATA cars;
 INPUT make $ model $ mpg weight price $;
DATALINES;
AMC Concord 22 2930 $4,099
AMC Pacer   17 3350 $4,749
AMC Spirit  22 2640 $3,799
Buick Century 20 3250 $4,816
Buick Electra 15 4080 $7,827
;
RUN;
* save the dataset file;
DATA _NULL_;
  SET cars;
  FILE  '~/Mydata/cars.dat';
  PUT make $ model $ mpg weight price;
RUN;

DATA cars;
 length make model $8; * specify the number of bytes to store vars;
 INFILE '~/Mydata/cars.dat';
 INPUT make $ model $ mpg weight 
       price:comma2.; * nonstandard values, use informat specifier *;
run;
PROC PRINT data = cars;
RUN; 

* create a data file *;
DATA cars2;
 INPUT make $ 1-5 model $ 6-12 mpg 13-14 weight 15-18 price 19-22;
 DATALINES;
AMC  Concord2229304099
AMC  Pacer  1733504749
AMC  Spirit 2226403799
BuickCentury2032504816
BuickElectra1540807827
;
RUN;


* save the data file *;
DATA _NULL_;
  SET cars2;
  FILE  '~/Mydata/cars2.dat';
  PUT make $ 1-5 model $ 6-12 mpg 13-14 weight 15-18 price 19-22;
RUN;

* read the data file using column input *;
DATA cars2;
  INFILE "~/Mydata/cars2.dat";
  INPUT make $ 1-5 model $ 6-12 mpg 13-14 weight 15-18 price 19-22;
RUN;

/* this one is not working...
DATA cars;
 INFILE '~/Mydata/cars2.dat';
 INPUT  @1 make $5.    *col1, width 5;
        @6 model $7.   *col6, width 7;
        @13 mpg 2.     *col13, width 2;
        @15 weight 4.  *col15, width 4
        @19 price 4.   *col19, width 4
        ;
run;
*/

DATA cars;
 INFILE '~/Mydata/cars2.dat';
 INPUT  make $5. 
        model $7. 
        mpg 2.
        @15 weight 4.
        @19 price 4. ;
run;




