/**************************************
CASE STUDY 11 - 04 - Data Preparation - Exercise 1
Data Prep Exercise 1: Missing Data and Outliers
File Used: DataPrep1.csv
STEP 6: Impact on Standard Deviation
*********************************************/


LIBNAME CS11E01 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy11_DataPreparation_Ex1/Datasets';





/**********************************************************
6. Replacing Top 2 values with Mean Value - calculating impact on Standard Deviation
***********************************************************/

/** Extracting one variable from DataPrep1 **/
DATA CS11E01.MINUSE1_ONE_VARIABLE;
	SET CS11E01.DataPrep1 (KEEP=minuse1);
RUN;


/** Sorting the single variable by descending order of minuse1 **/
PROC SORT
	DATA = CS11E01.MINUSE1_ONE_VARIABLE;
	BY DESCENDING minuse1;
RUN;


/** Creating a new Dataset starting from the 3rd observation in the table -
thereby dropping the 1st 2 ***/
DATA CS11E01.MINUSE1_ONE_VARIABLE_TOP_2_DROP;
	SET CS11E01.MINUSE1_ONE_VARIABLE (FIRSTOBS=3);
RUN;


/** Creating a dataset with 2 minuse1 records with the mean value **/
DATA CS11E01.ADD_MEAN_RECORDS;
	SET CS11E01.Tab_Mean_DataPrep2 (KEEP=MEAN_minuse1 RENAME=(MEAN_minuse1=minuse1));
	OUTPUT;
	OUTPUT;
	STOP;
RUN;


/** Appending the newly created 2 records to the dataset with the top 2 values dropped **/
PROC APPEND
	BASE = CS11E01.MINUSE1_ONE_VARIABLE_TOP_2_DROP
	DATA = CS11E01.ADD_MEAN_RECORDS;
RUN;
	

/** procedure to calculate the standard deviation 
after the removal of top 2 values replaced with MEAN value **/
PROC MEANS NOPRINT
	DATA = CS11E01.MINUSE1_ONE_VARIABLE_TOP_2_DROP;
	OUTPUT
		OUT=CS11E01.TAB_STDDEV_AFT_TOP2_REPLACED
		STDDEV(minuse1)=minuse1_aft_top2_replace;
RUN;


/** Merging the Original Standard Deviation and the newly calculated Standard Deviation
Creating a new value - Impact on to find the impact on STandard Deviation */
DATA CS11E01.MERGED_STDDEV_minuse1;
	MERGE 
		CS11E01.TAB_STDDEV_ORIGINAL(KEEP=minuse1_Original) 
		CS11E01.TAB_STDDEV_AFT_TOP2_REPLACED (KEEP=minuse1_aft_top2_replace);
	minuse1_Impact_On = minuse1_Original - minuse1_aft_top2_replace;
RUN;


/** Transposing the output for better reporting **/
PROC TRANSPOSE
	DATA = CS11E01.MERGED_STDDEV_minuse1
	OUT = CS11E01.MERGED_STDDEV_minuse1_Trans;
RUN;


/** printing the change in the STandard Deviation **/
PROC PRINT
	DATA = CS11E01.MERGED_STDDEV_minuse1_Trans (RENAME=(_NAME_=Description COL1=Value));
	TITLE1 "6. Replaced Top to values of Variable minuse1 with Mean of minuse1";
	TITLE2 "Impact on Standard Deviation is as follows: ";
RUN;
