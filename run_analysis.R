library(dplyr)

# reading all data frames
features = read.table("UCI HAR Dataset/features.txt", col.names = c("index","functions"))
activities = read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("label", "activity"))
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test = read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test = read.table("UCI HAR Dataset/test/y_test.txt", col.names = "label")
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train = read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train = read.table("UCI HAR Dataset/train/y_train.txt", col.names = "label")

# Merge the training and the test sets to create one data set
X = rbind(x_train, x_test)
Y = rbind(y_train, y_test)
Subject = rbind(subject_train, subject_test)
data = cbind(Subject, Y, X)
head(data)

# Extract only the measurements on the mean and standard deviation for each measurement
TidyData = data %>% select(subject, label, contains("mean"), contains("std"))
TidyData$label = activities[TidyData$label, 2]

# label the data set with descriptive variable names
names(TidyData)[2] = "activity"
names(TidyData)=gsub("Acc", "accelerometer", names(TidyData))
names(TidyData)=gsub("Gyro", "gyroscope", names(TidyData))
names(TidyData)=gsub("BodyBody", "body", names(TidyData))
names(TidyData)=gsub("Mag", "magnitude", names(TidyData))
names(TidyData)=gsub("^t", "time", names(TidyData))
names(TidyData)=gsub("^f", "frequency", names(TidyData))
names(TidyData)=gsub("tBody", "timebody", names(TidyData))
names(TidyData)=gsub("-mean()", "mean", names(TidyData), ignore.case = TRUE)
names(TidyData)=gsub("-std()", "std", names(TidyData), ignore.case = TRUE)
names(TidyData)=gsub("-freq()", "frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)=gsub("angle", "angle", names(TidyData))

# create a second, independent tidy data set with the average of each variable for each activity and each subject
FinalData = TidyData %>%group_by(subject, activity) %>%summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

