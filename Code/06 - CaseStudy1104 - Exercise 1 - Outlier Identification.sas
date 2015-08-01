/**************************************
CASE STUDY 11 - 04 - Data Preparation - Exercise 1
Data Prep Exercise 1: Missing Data and Outliers
File Used: DataPrep1.csv
STEP 6: Outlier Identification
*********************************************/


LIBNAME CS11E01 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy11_DataPreparation_Ex1/Datasets';




/****************************************************
5. How many outliers can you identify for each variable?
********************************************************/

/** adding Field variable to facilitate merge **/
DATA CS11E01.TAB_STDDEV_ORIGINAL2;
	SET CS11E01.TAB_STDDEV_ORIGINAL(DROP=_TYPE_ _FREQ_);
	FIELD=1;


/** Merging the Mean and the Standard Deviation Datasets with the entire data to help
calculate outliers **/
DATA CS11E01.DataPrep1_Merge_Mean_StdDev;
	MERGE 
		CS11E01.DataPrep2 Tab_Mean_DataPrep2 
		CS11E01.TAB_STDDEV_ORIGINAL2;
	BY FIELD;
RUN;


/** Calculating Outliers by checking if the value is within the mean ± 3X Standard Deviation */


/** minuse1 Outliers **/
DATA CS11E01.DataPrep1_minuse1_outliers ;
	SET CS11E01.DataPrep1_Merge_Mean_StdDev ;
	WHERE 
		( minuse1 > MEAN_minuse1 + (3*minuse1_Original) OR
		( ( minuse1 < MEAN_minuse1 - (3*minuse1_Original))  AND minuse1 ^= . ) ) ;
RUN;

/** Calculating the number of Outliers: minuse1 **/
PROC MEANS NOPRINT
	DATA = CS11E01.DataPrep1_minuse1_outliers;
	OUTPUT
		OUT=CS11E01.NOBS_minuse1_outliers
		N = minuse1_No_Of_Outliers;
RUN;


/** minuse2 Outliers **/
DATA CS11E01.DataPrep1_minuse2_outliers ;
	SET CS11E01.DataPrep1_Merge_Mean_StdDev;
	WHERE 
		minuse2 > MEAN_minuse2 + (3*minuse2_Original) OR
		( ( minuse2 < MEAN_minuse2 - (3*minuse2_Original))  AND minuse2 ^= . );
RUN;

/** Calculating the number of Outliers: minuse2 **/
PROC MEANS NOPRINT
	DATA = CS11E01.DataPrep1_minuse2_outliers;
	OUTPUT
		OUT=CS11E01.NOBS_minuse2_outliers
		N = minuse2_No_Of_Outliers;
RUN;



/** minuse3 Outliers **/
DATA CS11E01.DataPrep1_minuse3_outliers ;
	SET CS11E01.DataPrep1_Merge_Mean_StdDev;
	WHERE 
		minuse3 > MEAN_minuse3 + (3*minuse3_Original) OR
		( ( minuse3 < MEAN_minuse3 - (3*minuse3_Original))  AND minuse3 ^= . );
RUN;

/** Calculating the number of Outliers: minuse3 **/
PROC MEANS NOPRINT
	DATA = CS11E01.DataPrep1_minuse3_outliers;
	OUTPUT
		OUT=CS11E01.NOBS_minuse3_outliers
		N = minuse3_No_Of_Outliers;
RUN;


/** minuse4 Outliers **/
DATA DataPrep1_minuse4_outliers ;
	SET DataPrep1_Merge_Mean_StdDev;
	WHERE 
		minuse4 > MEAN_minuse4 + (3*minuse4_Original) OR
		( ( minuse4 < MEAN_minuse4 - (3*minuse4_Original))  AND minuse4 ^= . );
RUN;

/** Calculating the number of Outliers: minuse4 **/
PROC MEANS NOPRINT
	DATA = CS11E01.DataPrep1_minuse4_outliers;
	OUTPUT
		OUT=CS11E01.NOBS_minuse4_outliers
		N = minuse4_No_Of_Outliers;
RUN;


/** svc_start_dt Outliers **/
DATA CS11E01.DataPrep1_svc_start_dt_outliers ;
	SET CS11E01.DataPrep1_Merge_Mean_StdDev;
	WHERE 
		svc_start_dt > MEAN_svc_start_dt + (3*svc_start_dt_Original) OR
		( ( svc_start_dt < MEAN_svc_start_dt - (3*svc_start_dt_Original))  AND svc_start_dt ^= . );
RUN;

/** Calculating the number of Outliers: svc_start_dt **/
PROC MEANS NOPRINT
	DATA = CS11E01.DataPrep1_svc_start_dt_outliers;
	OUTPUT
		OUT=CS11E01.NOBS_svc_start_dt_outliers
		N = svc_start_dt_No_Of_Outliers;
RUN;


/** svc_end_dt Outliers **/
DATA CS11E01.DataPrep1_svc_end_dt_outliers ;
	SET CS11E01.DataPrep1_Merge_Mean_StdDev;
	WHERE 
		svc_end_dt > MEAN_svc_end_dt + (3*svc_end_dt_Original) OR
		( ( svc_end_dt < MEAN_svc_end_dt - (3*svc_end_dt_Original))  AND svc_end_dt ^= . );
RUN;

/** Calculating the number of Outliers: svc_end_dt **/
PROC MEANS NOPRINT
	DATA = CS11E01.DataPrep1_svc_end_dt_outliers;
	OUTPUT
		OUT=CS11E01.NOBS_svc_end_dt_outliers
		N = svc_end_dt_No_Of_Outliers;
RUN;


/** Birth_date Outliers **/
DATA CS11E01.DataPrep1_Birth_date_outliers ;
	SET CS11E01.DataPrep1_Merge_Mean_StdDev;
	WHERE 
		Birth_date > MEAN_Birth_date + (3*Birth_date_Original) OR
		( ( Birth_date < MEAN_Birth_date - (3*Birth_date_Original))  AND Birth_date ^= . );
RUN;

/** Calculating the number of Outliers: Birth_date **/
PROC MEANS NOPRINT
	DATA = CS11E01.DataPrep1_Birth_date_outliers;
	OUTPUT
		OUT=CS11E01.NOBS_Birth_date_outliers
		N = Birth_date_No_Of_Outliers;
RUN;


/** Merge all the number of outliers count value */
DATA CS11E01.MERGE_NOBS_OF_OUTLIERS;
	MERGE 
		CS11E01.NOBS_minuse1_outliers
		CS11E01.NOBS_minuse2_outliers
		CS11E01.NOBS_minuse3_outliers
		CS11E01.NOBS_minuse4_outliers
		CS11E01.NOBS_svc_start_dt_outliers
		CS11E01.NOBS_svc_end_dt_outliers
		CS11E01.NOBS_Birth_date_outliers;
RUN;

/** Transpose for better reporting **/
PROC TRANSPOSE
	DATA = 
		CS11E01.MERGE_NOBS_OF_OUTLIERS 
			(DROP=_TYPE_ _FREQ_)
	OUT = 
		CS11E01.MERGE_NOBS_OF_OUTLIERS_TRANS;
RUN;


/** Printing the value of number of Outliers per variable **/
PROC PRINT
	DATA = CS11E01.MERGE_NOBS_OF_OUTLIERS_TRANS 
		(
			RENAME=
				(
					_NAME_=Variable_Name 
					COL1=No_Of_Outliers
				)
		);
	TITLE1 "5. No of Outliers Per variable: ";
	TITLE2 "Outliers are calculated as those which fall below or beyond MEAN ± 3 Times Standard Deviation";
RUN;