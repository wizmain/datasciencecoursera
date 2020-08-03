
# Project File Url
har_data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# working folder and file
working_dir <- "./gettingcleaningdata"
working_dir_filename <- paste(working_dir,"har_data.zip", sep="/")

# Create Folder if not exits make folder
if( file.exists(working_dir) == FALSE ) {
  dir.create(working_dir)
}

# download data file
download.file(url=har_data_url, destfile=working_dir_filename)
# unzip zip file
unzip(zipfile=working_dir_filename, exdir=working_dir)

# read train files
X_train <- read.table(paste(working_dir,"/UCI HAR Dataset/train/X_train.txt",sep=""))
y_train <- read.table(paste(working_dir,"/UCI HAR Dataset/train/y_train.txt",sep=""))
subject_train <- read.table(paste(working_dir,"/UCI HAR Dataset/train/subject_train.txt",sep=""))


# read test files
X_test <- read.table(paste(working_dir,"/UCI HAR Dataset/test/X_test.txt",sep=""))
y_test <- read.table(paste(working_dir,"/UCI HAR Dataset/test/y_test.txt",sep=""))
subject_test <- read.table(paste(working_dir,"/UCI HAR Dataset/test/subject_test.txt",sep=""))

features <- read.table(paste(working_dir,"/UCI HAR Dataset/features.txt",sep=""))
activity_labels <- read.table(paste(working_dir,"/UCI HAR Dataset/activity_labels.txt", sep=""))

colnames(X_train) <- features[,2]
colnames(y_train) <- "activity_id"
colnames(subject_train) <- "subject_id"

colnames(X_test) <- features[,2]
colnames(y_test) <- "activity_id"
colnames(subject_test) <- "subject_id"

colnames(activity_labels) <- c("activity_id", "activity_type")


# 1.Merges the training and the test sets to create one data set
bind_all_train <- cbind(y_train, subject_train, X_train)
bind_all_test <- cbind(y_test, subject_test, X_test)
total_data <- rbind(bind_all_train, bind_all_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
col_names <- colnames(total_data)

mean_and_sd_colnames <- (grepl("activity_id", col_names)|
                  grepl("subject_id", col_names)|
                  grepl("mean..", col_names)|
                  grepl("std...", col_names))

# extract sub dataset
mean_and_sd_data <- total_data[, mean_and_sd_colnames==TRUE]

# 3. Uses descriptive activity name
mean_and_sd_data_name <- merge(mean_and_sd_data, activity_labels, by="activity_id", all.x=TRUE)

# 4. Appropriately labels the data set with descriptive variable names.

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject 

tidy_dataset <- aggregate(.~subject_id+activity_id, mean_and_sd_data_name, mean)
write.table(tidy_dataset, "tidy_dataset.txt", row.names=FALSE)
