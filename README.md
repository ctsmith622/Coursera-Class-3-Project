*Data reference:*

*[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*


# Explanation of analysis:
*Most of this description is also contained as comments in the run_analysis.R script itself.*

##Goal
Given the accelerometer readings data found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), the goal of this script was to produce a tidy dataset that:

1.  Consists of a single dataset.
2.  Pertains only to the variables in the original data that measure either the mean or standard of a motion type.
3.  Has a descriptive name for each column
4.  Has a descriptive label for the activity to which each mean value corresponds.
5.  Contains as its entries the mean value for each variable, for each unique subject-activity pair.

###  *The methodology section that follows will mark the point at which each of the above requirements is satisfied.*

##Assumption
The script assumes that the zip file and the URL that points to it are both valid.

##Methodology
###This section explains what the run_analysis.R script does 
The actions I took to arrive at the final tidy dataset are as follows:

1.  Download the zip file from the provided URL and unzip it
2.  Get the names of all directories and subdirectories contained in the unzipped folder, including all subdirectories.
3.  Remove the base level directory and the "Inertial Signals" subdirectories.
    *  I removed the inertial signals directories as suggested in the course discussion thread [here](https://class.coursera.org/getdata-012/forum/thread?thread_id=9). Also, they did not appear to be essential for creating the final tidy  dataset.
    *  I removed the base directory because it contained files that had non-numeric values and so it was simpler to read them in separately.
4.  Store the initial working directory so that it can be accessed later.
5.  Loop through the directories I found previously, and for each directory read all the files that have a .txt file extension.
    *  Each text file was assigned to a dataframe in the global environment with the same name as its source file.
6.  Set the working directory back to the original working directory
7.  Create the initial version of the merged data set by adding the activity and subject labels to their respective X values (using cbind).
    *  Do this for both the testing and training set
    *  Then add the new complete testing set to the end of the new complete training set (using rbind).
    *  This cbinded, then rbinded merged dataset will be what the rest of the analysis tries to tranform into the finished product.

#####Requirement #1 fulfilled: we now have a single dataframe

8.  Read in the file containing the activity descriptive labels (activity_labels.txt)
9.  Replace the previous numeric activity labels with the descriptive activity labels that were just read. (E.g., walking, laying, ...). 
    *  Since the numeric activity labels corresponded to row numbers in the activity_labels.txt table, I just looped through the column of numeric activity labels in the merged dataset, and replaced each value with the corresponding row from the activity_labels.txt. For example, if I was looking at a numeric activity label with the value '2', I would lookup the 2nd row in the activity_labels.txt table, and assign that value as the new activity label in the merged dataset.

#####Requirement #4 fulfilled: the activity labels are now descriptive E.g., "walking", "laying" as opposed to 1, 2

10.  Read in the file containing the descriptive column headers/variable names (features.txt)
11.  Find the features that relate to the mean or standard deviation for a given type of motion.
    *  *Note: the grepl() function in R returns a boolean indicator of whether or not a search term is contained within a given string.*
    *  Using grepl, identify the variable names that contain either the string "mean" or "std" after first converting the complete string to lower case.
12. Select only the columns from the merged dataset that correspond to the variable names that had to do with mean or standard deviation. Also, include the columns containing the subject number and the activity label.
    * Put these columns into a new dataset which will be our most current merged dataset. This is now the data we are working to improve.
    * At this point, we have a dataframe containing subject numbers,  descriptive activity labels, and all variables relating to mean or standard deviation. However, the mean and standard deviation variables still have generic column names like V1 and V2, so that's the next issue to address.

#####Requirement #2 fulfilled: all remaining columns are either the subject number, the activity label, or the contain the word "mean" or "std"

13.  Assign the descriptive variable names from features.txt above as the column names in this most current merged dataset. Manually set the column names for the subject number and activity label to "subject" and "activity" respectively. This dataset is now our most current merged dataset.

#####Requirement #3 fulfilled: All the columns now have descriptive labels taken from the features.txt document. 

14.  The final step is to calculate the mean for each unique combination of subject and activity for each column in our most current merged dataset. First, use the paste() function to concatenate the 'subject' and 'activity' columns, which gives you entries like '1 walking' and '3 laying'. 
15.  Use tapply, with the new 'subject-activity' combined variable as your grouping variable, to find the mean for each distinct subject-activity pair. Do this for each of the variable columns in the most current merged dataset (except for the activity and subject columns).
16.  Combine all of the resulting columns of means from tapply above into a new dataframe (should have the same number of columns as the most current merged data minus the 'activity' and 'subject columns'). This new dataset is our most current merged dataset.
17.  At this point, the subject-activity combined labels are the row names for the most current merged dataset, so in order to get them back into columns, set a new column in our most current dataset equal to the rownames of the most current dataset. 
18.  Using the separate() function in the tidyr package, split the new column of combined subject-activity labels into two new columns which contain the subject number and activity label respectively.
19.  Replace the previous column of combined subject-activity labels with the two new separated columns (activity, and subject)

#####Requirement #5 fulfilled: each column now contains the mean value of each mean or standard deviation variable for each unique subject-activity pair. 

##End of analysis


