
# Project Zip File Url
zip_file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# Set Working Directory and File Name
working_dir <- "./data"
zip_file_name <- "uci_har_dataset.zip"
filepath <- paste(working_dir,zip_file_name, sep="/")

# If not exists directory then make directory
if( file.exists(working_dir) == FALSE ) {
  dir.create(working_dir)
}

# download zip file
download.file(url=zip_file_url, destfile=filepath)
# unzip uci har zip file
unzip(zipfile=filepath, exdir=working_dir)

# read column info
features <- read.table(paste(working_dir,"/UCI HAR Dataset/features.txt",sep=""))
activity_labels <- read.table(paste(working_dir,"/UCI HAR Dataset/activity_labels.txt", sep=""))

head(features, 1)
dim(features)


# read train files
X_train <- read.table(paste(working_dir,"/UCI HAR Dataset/train/X_train.txt",sep=""))
y_train <- read.table(paste(working_dir,"/UCI HAR Dataset/train/y_train.txt",sep=""))
subject_train <- read.table(paste(working_dir,"/UCI HAR Dataset/train/subject_train.txt",sep=""))

# check data
head(X_train, 1)
dim(X_train)
colnames(X_train)
head(y_train, 1)
dim(y_train)
colnames(y_train)

# read test files
X_test <- read.table(paste(working_dir,"/UCI HAR Dataset/test/X_test.txt",sep=""))
y_test <- read.table(paste(working_dir,"/UCI HAR Dataset/test/y_test.txt",sep=""))
subject_test <- read.table(paste(working_dir,"/UCI HAR Dataset/test/subject_test.txt",sep=""))

# check data
head(X_test, 1)
dim(X_test)
colnames(X_test)
head(y_test, 1)
dim(y_test)
colnames(y_test)

# Appropriately labels the data set with descriptive variable names.
colnames(X_train) <- features[,2]
colnames(X_test) <- features[,2]
colnames(y_train) <- "activity_id"
colnames(y_test) <- "activity_id"
colnames(subject_train) <- "subject_id"
colnames(subject_test) <- "subject_id"

colnames(activity_labels) <- c("activity_id", "activity_type")


# Merges the training data
merged_all_train <- cbind(y_train, subject_train, X_train)
# Merges the test data
merged_all_test <- cbind(y_test, subject_test, X_test)
# Merges the train and test data
merged_data <- rbind(merged_all_train, merged_all_test)

# Extracts only the measurements on the mean and standard deviation for each measurement
col_names <- colnames(merged_data)

# Set extracts col names
extract_col_names <- col_names[grepl("mean..", col_names)
                            |grepl("std..", col_names)
                            |grepl("activity_id", col_names)
                            |grepl("subject_id", col_names)]
# check data
mean_col_names

# subset by extrat_col_names
merged_data_extrated <- merged_data[, mean_col_names]

# check data
head(merged_data_extrated, 5)

# Uses descriptive activity name
merged_data_act_id <- merge(merged_data_extrated, activity_labels, by="activity_id", all.x=TRUE)

# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject 
tidy_dataset <- aggregate(.~subject_id+activity_id, mean_and_sd_data_name, mean)

write.table(tidy_dataset, "tidy_dataset.txt", row.names=FALSE)
