*************************************************************************************
DATA103 Session3
Tips: highlight the code that you want to run and click icon 'Run' to see the result.
*************************************************************************************;


data work.kids;
   infile '~/Mydata/kids.dat';
   input name $ 1-8 siblings 10 
         @12 bdate mmddyy10. 
         @23 allowance comma2. 
         hobby1 $ hobby2 $ hobby3 $;
run;

data work.kids2;
   infile '~/Mydata/kids2.dat';
   input @1 name $8. 
         @10 siblings 1. 
         @12 bdate mmddyy10. 
         @23 allowance comma2. 
         @26 hobby1 $10.
         @36 hobby2 $10.
         @46 hobby3 $10.;
run;

data work.kids3;
   length hobby1 hobby2 hobby3 $ 10;
   infile '~/Mydata/kids3.dat';
   input name $ 
         siblings 
         bdate : mmddyy10. 
         allowance : comma2. 
         hobby1 $ 
         hobby2 $ 
         hobby3 $;
run;

data work.kids1;
   infile '~/Mydata/kids1.dat';
   input name $ 1-8 siblings 10 
         @12 bdate mmddyy10. 
         @23 allowance comma2. 
         hobby1 $ hobby2 $ hobby3 $;
run;

data work.kids4;
   infile '~/Mydata/kids4.dat' dlm=',';
   input name $ 
         siblings 
         bdate : mmddyy10. 
         allowance : comma2. 
         hobby1 : $10. 
         hobby2 : $10. 
         hobby3 : $10.;
run;

***Using DLM***;
data work.kids5;
   infile 'kids5.dat' dlm=',';
   input name $ 
         siblings 
         bdate : mmddyy10. 
         allowance : comma2. 
         hobby1 : $10. 
         hobby2 : $10. 
         hobby3 : $10.;
run;

***Using DSD***;
data work.kids5;
   infile '~/Mydata/kids5.dat' dsd;
   input name $ 
         siblings 
         bdate : mmddyy10. 
         allowance : comma2. 
         hobby1 : $10. 
         hobby2 : $10. 
         hobby3 : $10.;
run;

***Using Missover***;
data work.kids6;
   infile '~/Mydata/kids6.dat' missover;
   input name $ 
         siblings 
         bdate : mmddyy10. 
         allowance : comma2. 
         hobby1 : $10. 
         hobby2 : $10.  
         hobby3 : $10.;
run;

***Multiple INPUt statement***;
data work.kids8;
   infile '~/Mydata/kids8.dat';
   input name $ 1-8 
         siblings 10; 
   input @1 bdate mmddyy10. 
         @12 allowance comma2.; 
   input hobby1:$10. 
         hobby2:$10. 
         hobby3:$10.;
run;

***Using #Line Point Control***;
data work.kids8;
   infile '~/Mydata/kids8.dat';
   input name $ 1-8 
         siblings 10
       / @1 bdate mmddyy10. 
         @12 allowance comma2.
       / hobby1:$10. 
         hobby2:$10. 
         hobby3:$10.;
run;

***Using Single Trail @***;
data work.kids9;
   infile '~/Mydata/kids9.dat';
   input name $ 1-8 state $ 10-11 @;
   if state='IN' then 
      input @13 bdate mmddyy10. @24 allowance comma2. 
            hobby1:$10. hobby2:$10. hobby3:$10.;
   else input @13 hobby1:$10. hobby2:$10. hobby3:$10.;
run;

***Using Double Trail @***;
data work.kids10;
   infile '~/Mydata/kids10.dat';
   input name $ state $ @@;
run;

/* because Excel field names often have spaces */
options validvarname=any;
 
libname myxls xlsx '~/Mydata/Satscore.xlsx';

proc contents data=myxls._all_;
run;


libname myxls CLEAR;

