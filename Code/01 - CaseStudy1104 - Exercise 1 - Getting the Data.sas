/**************************************
CASE STUDY 11 - 04 - Data Preparation - Exercise 1
Data Prep Exercise 1: Missing Data and Outliers
File Used: DataPrep1.csv
STEP 1: Getting the Data
*********************************************/


LIBNAME CS11E01 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy11_DataPreparation_Ex1/Datasets';

/** Importing the Dataset **/
PROC IMPORT
	Datafile='/folders/myshortcuts/myfolder/Foundation Exercises/Assignments/Class11 - Data Exploration and Preparation/Data Preparation/DataPrep1.csv'
	DBMS=CSV
	REPLACE
	OUT=CS11E01.DataPrep_Incorrect_Birth;
RUN;


/**
Since Birth Dates like 1916 entered as 2016 into DATASET we are recreating the Birth Date Column
**/
DATA CS11E01.DataPrep_Correct_bdt;
	SET CS11E01.DataPrep_Incorrect_Birth;
	bdt_year=INT(BIRTH_DT/10000);
	bdt_month=MOD(INT(BIRTH_DT/100) , 100 );
	bdt_day = MOD(BIRTH_DT , 100 );
	Birth_date=mdy(bdt_month,bdt_day,bdt_year);
  	FORMAT Birth_date DATE9.;
RUN;


/** Dataset with the correct Date of Birth **/
DATA CS11E01.DataPrep1;
	SET CS11E01.DataPrep_Correct_bdt (DROP=BIRTH_DT bdt_year  bdt_month bdt_day bdt );
RUN;
