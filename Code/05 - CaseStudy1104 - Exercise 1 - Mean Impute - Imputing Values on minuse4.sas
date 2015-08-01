/**************************************
CASE STUDY 11 - 04 - Data Preparation - Exercise 1
Data Prep Exercise 1: Missing Data and Outliers
File Used: DataPrep1.csv
STEP 5: Imputing Minutes on Minuse4
*********************************************/


LIBNAME CS11E01 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy11_DataPreparation_Ex1/Datasets';



/*********************************************
4. Potential Ways of imputing minutes used 4 missing values
************************************************/

DATA CS11E01.MISSING_MINUSE4_DATASET;
	SET CS11E01.DataPrep1;
	WHERE minuse4 = .;
	FIELD=1;
RUN;

/** first print the missing rows with Empty minuse4 **/
PROC PRINT
	DATA = CS11E01.MISSING_MINUSE4_DATASET (DROP=FIELD);
	TITLE1 "4. Potential Ways of Imputing Missing values for minuse4";
	TITLE2 "First we print the rows with missing values";
	TITLE3 "We can either...";
	TITLE4 "(1) Take the Average minuse for the user and impute the Average value";
	TITLE5 "(2) OR we can take the Average minuse of the Plan and Imput that into the missing values";
	TITLE6 "(3) OR we can simply imput the Average Value of minuse4";
	TITLE7 "We will show the impact of teach of these strategies on the minuse4";
RUN;


/** using Strategy 1 - imputing the user's average into Minuse4 */
DATA CS11E01.MISSING_MINUSE4_W_USER_AVG;
	SET CS11E01.MISSING_MINUSE4_DATASET;
	minuse4 = MEAN(OF minuse1-minuse3);
RUN;


/** Printing Strategy (1) - IMPUTING USER AVERAGE to minuse4 **/ 
PROC PRINT
	DATA = CS11E01.MISSING_MINUSE4_W_USER_AVG (DROP = FIELD);
	TITLE1 "4. (1) Imputing the User's Average into minuse4";
RUN;


/** calculating the mean of the PLAN_TYPE */
PROC MEANS MEAN NOPRINT 
	DATA = CS11E01.DataPrep1;
	VAR minuse4;
	CLASS PLAN_TYPE;
	OUTPUT 
		OUT = CS11E01.PLAN_TYPE_MEAN
		MEAN(minuse4) = Plan_Type_Mean;
RUN;

/** Sorting the MISSING_MINUSE4_DATASET by Plan_Type to merge with PLANT_TYPE_MEAN */
PROC SORT
	DATA = CS11E01.MISSING_MINUSE4_DATASET;
	BY PLAN_TYPE;
RUN;
	

/** Left Join MISSING_MINUSE4_DATASET with PLAN_TYPE_MEAN 
ALSO Setting the value of minuse4 to Plan_Type_Mean
*/
DATA CS11E01.MISSING_MINUSE4_W_PLAN_TYPE_AVG;
	MERGE 
		CS11E01.MISSING_MINUSE4_DATASET (IN = A)
		CS11E01.PLAN_TYPE_MEAN (DROP=_TYPE_ _FREQ_);
	BY PLAN_TYPE;
	IF A;
	minuse4 = Plan_Type_Mean;
RUN;


/** Printing Strategy (2) - IMPUTING PLAN_TYPE_MEAN to missing values of minuse4 **/ 
PROC PRINT
	DATA = CS11E01.MISSING_MINUSE4_W_PLAN_TYPE_AVG (DROP=FIELD Plan_Type_Mean);
	TITLE1 "4. (2) Imputing the User's Average into minuse4";
RUN;


/** Merging the column Average Tab_Mean_DataPrep2 with the MISSING_MINUSE4_DATASET */
DATA CS11E01.MISSING_MINUSE4_W_COLUMN_AVG;
	MERGE 
		CS11E01.MISSING_MINUSE4_DATASET 
		CS11E01.Tab_Mean_DataPrep2 (KEEP=FIELD MEAN_minuse4);
	BY FIELD;
	minuse4 = MEAN_minuse4;
RUN;


/** Printing Strategy (3) - IMPUTING minuse4 column MEAN to missing values of minuse4 **/ 
PROC PRINT
	DATA = CS11E01.MISSING_MINUSE4_W_COLUMN_AVG (DROP=FIELD MEAN_minuse4);
	TITLE1 "4. (3) Imputing the User's Average into minuse4";
RUN;