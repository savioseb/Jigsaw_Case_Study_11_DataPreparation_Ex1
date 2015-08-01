/**************************************
CASE STUDY 11 - 04 - Data Preparation - Exercise 1
Data Prep Exercise 1: Missing Data and Outliers
File Used: DataPrep1.csv
STEP 3: Total Loss of Records
*********************************************/


LIBNAME CS11E01 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy11_DataPreparation_Ex1/Datasets';


/*******************************************************
2. What is the total loss of records if all missing value records are deleted
*******************************************************/

/** Creating another Dataset with Missing Values Removed */
DATA CS11E01.DataPrep_Missing_Values_Removed;
	SET CS11E01.DataPrep1;
	IF CMISS(OF _all_) THEN DELETE;
RUN;


/** Finding the number of Rows in Original And Modified Datasets */
PROC SQL NOPRINT;
	SELECT count(*) INTO : NOBS_ORIGINAL
   		FROM CS11E01.DataPrep1;
    SELECT count(*) INTO : NOBS_DELETED
   		FROM CS11E01.DataPrep_Missing_Values_Removed;
QUIT;

/** Compiling the Counts into a Table and Calculating Total Loss of Records */ 
DATA CS11E01.No_Of_Observations;
	No_Of_Obs_In_Original_Dataset = &NOBS_ORIGINAL;
	No_Of_Obs_If_Missing_Deleted = &NOBS_DELETED;
	Total_Loss_Of_Records = No_Of_Obs_In_Original_Dataset - No_Of_Obs_If_Missing_Deleted;
RUN;


/** Transposing the table for clean output */
PROC TRANSPOSE
	DATA = CS11E01.No_Of_Observations
	OUT = CS11E01.No_Of_Observations2;
RUN;


/** Printing the Total Loss of Records if Observations with Missing Values are Deleted */
PROC PRINT NOOBS
	DATA = CS11E01.No_Of_Observations2 (RENAME=(_NAME_=Description COL1=Count));
	TITLE1 "2. Total Loss of Records if Observations with Missing Values are Deleted";
RUN;