# Explanation of run_analysis.R script:
*Most of this description is also contained as comments in the run_analysis.R script itself.*

##Goal
Given the data describing accelerometer readings found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), the goal of this script was to produce a tidy dataset fulfilling several requirements. 

The final tidy data set must:

1.  Consist of a single dataset.
2.  Pertain only to the variables in the original data that measure either the mean or standard of a motion type.
3.  Have a descriptive name for each column
4.  Have a descriptive label for the activity to which each mean value corresponds.
5.  Contain as its entries (rows) the mean value for each variable, for each unique subject-activity pair.

##Assumption
The script assumes that the zip file and the URL that points to it are both valid.

##Methodology

