/**************************************
CASE STUDY 11 - 04 - Data Preparation - Exercise 1
Data Prep Exercise 1: Missing Data and Outliers
File Used: DataPrep1.csv
STEP 4: Impact of Imputing Missing Values
*********************************************/


LIBNAME CS11E01 '/folders/myshortcuts/myfolder/SSCode/JigsawCaseStudy11_DataPreparation_Ex1/Datasets';


/**********************************************************
3. IMPACT OF IMPUTING MEAN VALUE INTO MISSING VALUES ON STANDARD DEVIATION
**********************************************************/


/** PROC MEANS to get the MEAN of Each Variable **/
PROC MEANS NOPRINT
	DATA = CS11E01.DataPrep1;
	OUTPUT 
		OUT=CS11E01.Tab_Mean_DataPrep1
		
		MEAN(sbscrp_id)=MEAN_sbscrp_id
		MEAN(minuse1)=MEAN_minuse1
		MEAN(minuse2)=MEAN_minuse2
		MEAN(minuse3)=MEAN_minuse3
		MEAN(minuse4)=MEAN_minuse4
		MEAN(prom2)=MEAN_prom2
		MEAN(prom3)=MEAN_prom3
		MEAN(prom4)=MEAN_prom4
		MEAN(prom5)=MEAN_prom5
		MEAN(svc_start_dt)=MEAN_svc_start_dt
		MEAN(svc_end_dt)=MEAN_svc_end_dt
		MEAN(Birth_date)=MEAN_Birth_date
		MEAN(zip_code)=MEAN_zip_code;
RUN;


/** PROC MEANS to get the STDDEV OF EACH VARIABLE 
BEFORE IMPUTING MEAN VALUE TO MISSING VALUES **/		
PROC MEANS NOPRINT
	DATA = CS11E01.DataPrep1;
	OUTPUT
		OUT=CS11E01.TAB_STDDEV_ORIGINAL		
		STDDEV(sbscrp_id)=sbscrp_id_Original
		STDDEV(minuse1)=minuse1_Original
		STDDEV(minuse2)=minuse2_Original
		STDDEV(minuse3)=minuse3_Original
		STDDEV(minuse4)=minuse4_Original
		STDDEV(prom2)=prom2_Original
		STDDEV(prom3)=prom3_Original
		STDDEV(prom4)=prom4_Original
		STDDEV(prom5)=prom5_Original
		STDDEV(svc_start_dt)=svc_start_dt_Original
		STDDEV(svc_end_dt)=svc_end_dt_Original
		STDDEV(Birth_date)=Birth_date_Original
		STDDEV(zip_code)=zip_code_Original;
RUN;

/** Creating a Column to Merge By ID to enable ONE-to-MANY MERGE */
DATA CS11E01.Tab_Mean_DataPrep2;
	SET CS11E01.Tab_Mean_DataPrep1 (DROP=_TYPE_ _FREQ_);
	FIELD=1;
RUN;

/** Creating a Column to Merge By ID to enable ONE-to-MANY MERGE */
DATA CS11E01.DataPrep2;
	SET CS11E01.DataPrep1;
	FIELD=1;
RUN;


/** ONE-to-MANY MERGE to have the MEAN Values in every Row
Check if there are any variables which are missing and impute the MEAN Value of that variable
*/
DATA CS11E01.Merged_DataPrep_With_Means;
	MERGE CS11E01.DataPrep2 CS11E01.Tab_Mean_DataPrep2;
	BY FIELD;
	IF sbscrp_id = . THEN sbscrp_id=Mean_sbscrp_id;
	IF minuse1 = . THEN minuse1=Mean_minuse1;
	IF minuse2 = . THEN minuse2=Mean_minuse2;
	IF minuse3 = . THEN minuse3=Mean_minuse3;
	IF minuse4 = . THEN minuse4=Mean_minuse4;
	IF prom2 = . THEN prom2=Mean_prom2;
	IF prom3 = . THEN prom3=Mean_prom3;
	IF prom4 = . THEN prom4=Mean_prom4;
	IF prom5 = . THEN prom5=Mean_prom5;
	IF svc_start_dt = . THEN svc_start_dt=Mean_svc_start_dt;
	IF svc_end_dt = . THEN svc_end_dt=Mean_svc_end_dt;
	IF Birth_date = . THEN Birth_date=Mean_Birth_date;
	IF zip_code = . THEN zip_code=Mean_zip_code;	
RUN;
		
		
/** PROC MEANS to get the STDDEV OF EACH VARIABLE **/		
PROC MEANS NOPRINT
	DATA = CS11E01.Merged_DataPrep_With_Means;
	OUTPUT
		OUT=CS11E01.TAB_STDDEV_AFTER_IMPUTE		
		STDDEV(sbscrp_id)=sbscrp_id_After_Impute
		STDDEV(minuse1)=minuse1_After_Impute
		STDDEV(minuse2)=minuse2_After_Impute
		STDDEV(minuse3)=minuse3_After_Impute
		STDDEV(minuse4)=minuse4_After_Impute
		STDDEV(prom2)=prom2_After_Impute
		STDDEV(prom3)=prom3_After_Impute
		STDDEV(prom4)=prom4_After_Impute
		STDDEV(prom5)=prom5_After_Impute
		STDDEV(svc_start_dt)=svc_start_dt_After_Impute
		STDDEV(svc_end_dt)=svc_end_dt_After_Impute
		STDDEV(Birth_date)=Birth_date_After_Impute
		STDDEV(zip_code)=zip_code_After_Impute;
RUN;


/** Merging the Standard Deviation calculations before and after imputing average values **/
DATA CS11E01.MERGED_STDDEVS;
	MERGE 
		CS11E01.TAB_STDDEV_ORIGINAL (DROP=_TYPE_ _FREQ_) 
		CS11E01.TAB_STDDEV_AFTER_IMPUTE (DROP=_TYPE_ _FREQ_);
	sbscrp_id_Impact_On=sbscrp_id_After_Impute - sbscrp_id_Original;
	minuse1_Impact_On = minuse1_After_Impute-minuse1_Original;
	minuse2_Impact_On = minuse2_After_Impute - minuse2_Original;
	minuse3_Impact_On = minuse3_After_Impute - minuse3_Original;
	minuse4_Impact_On = minuse4_After_Impute - minuse4_Original;
	prom2_Impact_On = prom2_After_Impute - prom2_Original;
	prom3_Impact_On = prom3_After_Impute - prom3_Original;
	prom4_Impact_On = prom4_After_Impute - prom4_Original;
	prom5_Impact_On = prom5_After_Impute - prom5_Original;
	svc_start_dt_Impact_On = svc_start_dt_After_Impute - svc_start_dt_Original;
	svc_end_dt_Impact_On = svc_end_dt_After_Impute - svc_end_dt_Original;
	Birth_date_Impact_On = Birth_date_After_Impute - Birth_date_Original;
	zip_code_Impact_On = zip_code_After_Impute - zip_code_Original;
RUN;	


/** Transposing the table for clean output */
PROC TRANSPOSE
	DATA = CS11E01.MERGED_STDDEVS
	OUT = CS11E01.MERGED_STDDEVS_TRANSPOSED;
RUN;

PROC SORT
	DATA=CS11E01.MERGED_STDDEVS_TRANSPOSED;
	BY _NAME_;
RUN;

/** Printing the result - impact of imputing average values into missing values **/
PROC PRINT
	DATA = CS11E01.MERGED_STDDEVS_TRANSPOSED (RENAME=(_NAME_=Name COL1=Value));
	TITLE1 "3. Impact on Standard Deviation if Missing Values are imputed with Average Values";
	TITLE2 "Ordered List of variables with values After Imputing, Before Imputing and the Impact";
RUN;


PROC TRANSPOSE
	DATA = CS11E01.MERGED_STDDEVS(KEEP=sbscrp_id_Impact_On
		minuse1_Impact_On
		minuse2_Impact_On
		minuse3_Impact_On
		minuse4_Impact_On
		prom2_Impact_On
		prom3_Impact_On
		prom4_Impact_On
		prom5_Impact_On
		svc_start_dt_Impact_On
		svc_end_dt_Impact_On
		Birth_date_Impact_On
		zip_code_Impact_On)
	OUT = CS11E01.MERGED_STDDEVS_IMAPACT_ON;
RUN;

/** Specifically Printing only those that had an impact on average values ***/
PROC PRINT
	DATA = CS11E01.MERGED_STDDEVS_IMAPACT_ON (RENAME=(_NAME_=Name COL1=Value));
	TITLE1 "Specifically Printing out the Impact Values";
RUN;