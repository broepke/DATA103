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