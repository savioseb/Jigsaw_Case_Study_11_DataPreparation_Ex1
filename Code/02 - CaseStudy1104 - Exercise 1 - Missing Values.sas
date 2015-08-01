/**************************************
CASE STUDY 11 - 04 - Data Preparation - Exercise 1
Data Prep Exercise 1: Missing Data and Outliers
File Used: DataPrep1.csv
STEP 1: Getting the Data
*********************************************/


LIBNAME CS11E01 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy11_DataPreparation_Ex1/Datasets';



/*************************************************
1. Printing out Variables with missing Values
**************************************************

/** MEANS PROC OUTput to get the No of missing Variables ***/
PROC MEANS NOPRINT
	DATA = CS11E01.DataPrep1;
	OUTPUT 
		OUT=CS11E01.TAB_MISSING
		NMISS(sbscrp_id)=sbscrp_id
		NMISS(minuse1)=minuse1
		NMISS(minuse2)=minuse2
		NMISS(minuse3)=minuse3
		NMISS(minuse4)=minuse4
		NMISS(prom2)=prom2
		NMISS(prom3)=prom3
		NMISS(prom4)=prom4
		NMISS(prom5)=prom5
		NMISS(svc_start_dt)=svc_start_dt
		NMISS(svc_end_dt)=svc_end_dt
		NMISS(Birth_date)=Birth_date
		NMISS(zip_code)=zip_code;
RUN;

		
/** Transposing the Columns to Rows to give a better output **/		
PROC TRANSPOSE
	DATA = CS11E01.TAB_MISSING (DROP=_TYPE_ _FREQ_)
	OUT = CS11E01.LONG_TAB_MISSING;
RUN;

	
/** Counting the Missing Values in Categorical Variable: Plan_Type 
and saving it into a dataset */
PROC FREQ NOPRINT
	DATA = CS11E01.DataPrep1; 
	TABLES Plan_Type / MISSING OUT=CS11E01.TAB_FREQ_Plan_Type;
	TABLES NEW_CELL_IND / MISSING  OUT=CS11E01.TAB_FREQ_NEW_CELL_IND;
RUN;

/** Extracting the count of missing values */
DATA CS11E01.TAB_FREQ_Plan_Type1;
	SET CS11E01.TAB_FREQ_Plan_Type (DROP= PERCENT);
	IF Plan_Type = ' ';
RUN;


/* Renaming the Column Names and the Variable name */
DATA CS11E01.TAB_FREQ_Plan_Type2;
	RETAIN _NAME_ COL1;
	SET CS11E01.TAB_FREQ_Plan_Type1 
		(
			DROP=Plan_Type 
			RENAME=(COUNT=COL1)
		);
	_NAME_ = 'Plan_Type' ;
RUN;


/** Counting the Missing Values in Categorical Variable: NEW_CELL_IND 
and saving it into a dataset */
DATA CS11E01.TAB_FREQ_NEW_CELL_IND1;
	SET CS11E01.TAB_FREQ_NEW_CELL_IND (DROP= PERCENT);
	IF NEW_CELL_IND = ' ';
RUN;


/* Renaming the Column Names and the Variable name */
DATA CS11E01.TAB_FREQ_NEW_CELL_IND2;
	RETAIN _NAME_ COL1;
	SET CS11E01.TAB_FREQ_NEW_CELL_IND1 
		(
			DROP=NEW_CELL_IND 
			RENAME=(COUNT=COL1)
		);
	_NAME_ = 'NEW_CELL_IND';
RUN;


/** Specifically Merging only those oberservations which have missing values */
DATA CS11E01.MISSING_VARIABLES_MERGE;
	SET 
		CS11E01.LONG_TAB_MISSING CS11E01.TAB_FREQ_Plan_Type2  
		CS11E01.TAB_FREQ_NEW_CELL_IND2;
	WHERE COL1 > 0;
RUN;


/** Sorting the Missing variables by Descending order of number of Missing Observations */
PROC SORT
	DATA = CS11E01.MISSING_VARIABLES_MERGE 
		(
			RENAME=(
				_NAME_=Variable_Name 
				COL1=No_Of_Missing_Values
			) 
		);
	BY DESCENDING No_Of_Missing_Values;
RUN;


/** Finding the number of Rows in MISSING_VARIABLES_MERGE Dataset */
PROC SQL NOPRINT;
	SELECT count(*) INTO : NOBS_MISSING_VARIABLES
   		FROM CS11E01.MISSING_VARIABLES_MERGE;
QUIT;


DATA CS11E01.No_Of_Vars_With_Missing_Values;
	Description="No of Variables with Missing Values";
	Count=&NOBS_MISSING_VARIABLES;
RUN;

/** Printing No of Variables With Missing Values */
PROC PRINT NOOBS
	DATA = CS11E01.No_Of_Vars_With_Missing_Values;
	TITLE1 "**************************************************";
	TITLE2 "Data Prep Exercise 1: Missing Data and Outliers";
	TITLE3 "USING  DataPrep1.csv";
	TITLE4 "***************************************************";
	TITLE5 "1. Number of Variables With Missing Values";
RUN;


/** Printing out the variables with missing values along with the number of missing values */
PROC PRINT 
	DATA = CS11E01.MISSING_VARIABLES_MERGE;
	TITLE1 "Variables with Missing Values in Descending order of Count of Missing Values";
RUN;

