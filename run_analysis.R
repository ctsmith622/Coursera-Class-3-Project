#Assumption: The file and URL pointing to it are still valid 
#Download the zip file and unzip the contents in the working directory
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "data.zip", quiet = F)
unzip("data.zip")

#Get the names of all the directories you unzipped, including all sub-directories
directories <- list.dirs(path = "~/Coursera/Class_3/UCI HAR Dataset/", recursive = T)

#remove the base level directory since we only want the test and train subdirectories
directories <- directories[-1]

#remove the Inertial Signals directories
directories <- directories[!sapply(directories, function(x) grepl(pattern = "Inertial", x))]

#store the starting working directory in a variable for later access
original_wd <- getwd()

#initialize a list with length equal to the number of directories. 
#Each element will contain all the .txt files in a given directory.
txt_files <- vector(mode = "list", length = length(directories))

#loop through the directories, using Sys.glob to find all the files within the directories with a .txt extension
#then for each of these text files, read it in as a table to the global environment. Give each one the same name as its source file
for(i in 1:length(directories)){
  setwd(directories[i])
  txt_files <- Sys.glob("*.txt")
  if(length(txt_files) > 0){
    for(j in txt_files){
      assign(x = paste(j, sep = ""), value = read.table(j, header = F, colClasses = "numeric", as.is = T), envir = .GlobalEnv)
    }
  }
}
rm(i,j)

#set working directory back to the original
setwd(original_wd)

#create the initial merged data sets by adding the test and training Y values and subject labels to their respective X values.
#Then add the rows of the combined test set to the end of the training set
merged_data <- rbind(cbind(X_train.txt, subject_train.txt, y_train.txt), cbind(X_test.txt, subject_test.txt, y_test.txt))

#read the text file containing the four activity labels
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F, header = F)[,2]

#now re-label the activity column (column 563) with the labels contained in 'activities'
merged_data[,563] <- sapply(merged_data[,563], function(x) activities[x])

#read in the text file containing the names of the variables
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = F, header = F)[,2]

#extract the indices of the variable names that contain reference to either mean or standard deviation
mean_or_std_boolean <- sapply(features, function(x) grepl(pattern = "mean", x = tolower(x)) | grepl(pattern = "std", x = tolower(x)))
mean_or_std_indices <- which(mean_or_std_boolean)

#create a new dataframe that contains only the columns which reference mean or standard deviation (std), making sure to also keep
#   the columns containing the activity label and the subject number
mean_std_data <- merged_data[, c(mean_or_std_indices, 562, 563)]

#assign descriptive names to the columns of the new dataframe using the variable names from 'features'
names(mean_std_data) <- c(features[mean_or_std_indices], "subject", "activity")


#Begin the final step of creating a new tidy dataset that contains the mean for each variable for each unique subject-activity pair
#Start by creating a new combined variable that concatenates the subject number and the activity being performed
subject_activity <- paste(mean_std_data$subject, mean_std_data$activity)

#now use that new variable as the grouping factor to calculate the mean for all the numeric variables
#   the tapply part below calculates the mean for each subject-activity pair within a single column
#   the sapply function simply applies the tapply bit to each column in 'mean_std_data'. The list operator 'sapply' works here because
#     a dataframe is really just a list of vectors.
#   I subtract out columns 87 and 88 in the call to sapply because they are non-numeric. I will re-assign those values later using tidyr
tidy_means <- as.data.frame(sapply(mean_std_data[, -c(87:88)], function(x) tapply(x, INDEX = subject_activity, FUN = mean)))

#set the row names (subject-activity pairs) to a column so that it can be easily accessed
tidy_means$subj_act <- row.names(tidy_means)

#finally use tidyr to split the subject-activity pairs back into the separate subject and activity labels
library(tidyr)
tidy_means_final <- separate(tidy_means, col = subj_act, into = c("subject", "activity"), sep = " ")

#rearrange columns to put subject number and activity label in the first two columns
tidy_means_final <- tidy_means_final[, c(87, 88, 1:86)]

#export as .txt file named tidy_means.txt
write.table(tidy_means_final, file = "tidy_means.txt", row.names = F)
