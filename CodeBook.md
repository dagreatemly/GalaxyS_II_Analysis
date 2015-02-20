CODE BOOK
-----------------------------------------------------------
PART I: Variables & Units in Output Dataset
subject (30)
	Each number identifies a unique subject in the Samsung study.

activity (6)
Each observation in the study was taken (and data gathered) when the observed subject was engaged in one of six activities:

        	WALKING
        	WALKING_UPSTAIRS
     	WALKING_DOWNSTAIRS
        	SITTING
        	STANDING
        	LAYING

stat (2)
The output dataset reflects the project's directive to extract the (1) means and (2) means of standard deviations of multiple observations taken with respect to 33 different metrics, given a subject and an activity.  Therefore, this column specifies whether the value is a mean of the outcomes, or of the standard deviation associated with that particular observation.  "std" denotes the latter value.
        	mean
        	std
        
feature (33)
The observations in the Samsung study consisted data on 33 measures, which are listed in the "features_info.txt" file provided.  Even though at first glance there seem to be only 17 features or measures, 8 of these features are actually dealt with as three separate features, one for each axis in 3D.  Therefore there are 16 more features to add to the 17, and hence the study measured 33 signals in each observation.
	fBodyAcc ()-X           
	fBodyAcc ()-Y          
 	fBodyAcc ()-Z           
	fBodyAccJerk ()-X      
 	fBodyAccJerk ()-Y       
	fBodyAccJerk ()-Z      
 	fBodyAccMag ()          
	fBodyBodyAccJerkMag () 
 	fBodyBodyGyroJerkMag () 
	fBodyBodyGyroMag ()    
 	fBodyGyro ()-X          
	fBodyGyro ()-Y         
 	fBodyGyro ()-Z          
	tBodyAcc ()-X          
 	tBodyAcc ()-Y           
	tBodyAcc ()-Z          
 	tBodyAccJerk ()-X       
	tBodyAccJerk ()-Y      
 	tBodyAccJerk ()-Z      
 	tBodyAccJerkMag ()     
 	tBodyAccMag ()          
	tBodyGyro ()-X         
 	tBodyGyro ()-Y          
	tBodyGyro ()-Z         
 	tBodyGyroJerk ()-X      
	tBodyGyroJerk ()-Y     
 	tBodyGyroJerk ()-Z      
	tBodyGyroJerkMag ()    
 	tBodyGyroMag ()         
	tGravityAcc ()-X       
 	tGravityAcc ()-Y        
	tGravityAcc ()-Z       
 	tGravityAccMag ()

value     
This column give the mean of the measures identified in the previous column given a subject and activity, or of the standard deviations thereof.  
    
-----------------------------------------------------------
PART 2: STUDY DESIGN
Before merging/combining the text and training datasets, I applied the following process to each.
1) Both the X-train and X-test had 561 columns, the number of total statistics derived from the 33 types of signals measured.  
2) The character vector extracted from features.txt had duplicates, which prevented effective use of the select method from the dplyr library.
3) After assigning the duplicative entries in features to unique values, the 561-long vector was assigned the column names of the X-train and X-test datasets, which also had 561 columns.
4) After ensuring that none of the duplicative entries in features identified a mean or standard deviation of some sort, the select function was used to extract from the X-datasets only those columns whose names contained either the string mean() or std().  This resulted in the elimination of 561 - 66 = 495 columns, each of length 7352, equivalent to upwards of 3.6 million.  At a cost of 4 bytes per entry, that means that the limitation in the project (to mean and standard deviation) saved approximately 14.4 MB.
5) For each X-dataset, after the shedding in step 4 above, the subjects and activities (decoded to reflect the activities via character strings) were cbinded to their associate X-dataset.
6) After the steps above, each X-dataset has the same number of columns, with corresponding column names.  As such, it is possible to rbind the two X-datasets to get a dataset that included observations for all users.
7) Split the data via the interaction of two variables, subject and activity, and squash so to speak, each dataset with identical subject-activity pairs by taking the mean of all the values in each column.  
8) This leaves a dataframe of 180 observations on 68 variables/columns.
9) The resulting 180 x 68 dataframe does NOT satisfy the requirements of a tidy dataset.
10) How this dataframe is made tidy is explained in the Readme.md file.  It bears noting, however, that we will no longer be throwing any values away.  We have (68 - 2) * (180) = 11,880 mean/standard deviation values we need to organize.  As is shown in the Readme file, that's precisely how many mean/standard deviation values are given by the tidy output.


      
