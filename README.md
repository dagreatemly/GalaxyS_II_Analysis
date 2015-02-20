# Galaxy S II Gyrometer/Accelerometer Analysis
The extraction of certain statistics was done on data compiled in experiments conducted by the International Workshop of Ambient Assited Living in December 2012. [1]

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

The CodeBook describes how the "run_analysis.R" script produces at some point a 180 by 68 dataframe that does not comply with the tidy data principles outlined during the course.  First, columns 3 through 68 are values, not variables; in particular, they are inputs to the variable representing what kind of data we need.  We partially remedy this problem using the gather() function from the dplyr package with the following arguments: s (the untidy dataset), stat_feature (the "key" argument identified in the gather() documentation), -subject (which IS a valid variable and is thus left alone), -activity (ditto).

sgat <- gather(s, stat_feature, value, -subject, -activity)

sgat has the following variables: subject, activity, stat_feature, and value.

This improves on the original, but the "stat_feature" variable is still in violation of the prohibition against having two variables represented in a single column.  What we want are two separate columns, one for the signal being observed, and one for the statistic to derive from the resultant data.

Call the separate() function: ssep <- separate(sgat, stat_feature, c("stat", "feature")).

We're left with a clean dataset.  The feature column displays a bunch of numbers, but they can easily be converted back into the character strings corresponding to that particular number.  We can use a process similar to that used earlier to convert activity number IDs to character strings that better described the activity being observed. 
