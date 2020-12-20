DATA temp;
	input @1 ID 4.
        @6 First $11.
		@18 Last $6.
		+1 Height 2.
		+1 Weight 3.
        +1 Date mmddyy8.
        +1 Calories comma5.;
	DATALINES;
1024 Alice       Smith  65 125 12/1/95  2,036
1167 Maryann     White  68 140 12/01/95 1,800
1168 Thomas      Jones     190 12/2/95  2,302
1201 Benedictine Arnold 68 190 11/30/95 2,432
1302 Felicia     Ho     63 115 1/1/96   1,972
  ;
RUN;

PROC PRINT data=temp;
RUN;