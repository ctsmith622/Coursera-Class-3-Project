# Explanation of analysis:
*Most of this description is also contained as comments in the run_analysis.R script itself.*

##Goal
Given the accelerometer readings data found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), the goal of this script was to produce a tidy dataset that:

1.  Consists of a single dataset.
2.  Pertains only to the variables in the original data that measure either the mean or standard of a motion type.
3.  Has a descriptive name for each column
4.  Has a descriptive label for the activity to which each mean value corresponds.
5.  Contains as its entries the mean value for each variable, for each unique subject-activity pair.

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
    *  Do this for bother the testing and training set
    *  Then add the new complete testing set to the end of the new complete training set (using rbind).
    *  This cbinded, then rbinded merged dataset will be what the rest of the analysis tries to tranform into the finished product.

#####Requirement #1 fulfilled

8.  Read in the file containing the activity descriptive labels (activity_labels.txt)
9.  Replace the previous numeric activity labels with the descriptive activity labels that were just read. (E.g., walking, laying, ...). 
    *  Since the numeric activity labels corresponded to row numbers in the activity_labels.txt table, I just looped through the column of numeric activity labels in the merged dataset, and replaced each value with the corresponding row from the activity_labels.txt. For example, if I was looking at a numeric activity label with the value '2', I would lookup the 2nd row in the activity_labels.txt table, and assign that value as the new activity label in the merged dataset.

#####Requirement #4 fulfilled

10.  Read in the file containing the descriptive column headers/variable names (features.txt)
11.  Find the features that relate to the mean or standard deviation for a given type of motion.
    *  *Note: the grepl() function in R returns a boolean indicator of whether or not a search term is contained within a given string.*
    *  Using grepl, identify the variable names that contain either the string "mean" or "std" after first converting the complete string to lower case.
12. Select only the columns from the merged dataset that correspond to the variable names that had to do with mean or standard deviation. Also, include the columns containing the subject number and the activity label.
    * Put these columns into a new dataset which will be our most current merged dataset. This is now the data we are working to improve.

#####Requirement #2 fulfilled

13.  Assign the descriptive variable names from features.txt above as the column names in this most current merged dataset. Manually set the column names for the subject number and activity label to "subject" and "activity" respectively.

#####Requirement #3 fulfilled




