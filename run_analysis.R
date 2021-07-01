#setting work directory#
pathdata <- file.path("C:/Users/manue/Desktop/UCI HAR Dataset/")

#reading each file#
xtest <- read.table(file.path(pathdata, "test", "X_test.txt"))
ytest <- read.table(file.path(pathdata, "test", "y_test.txt"))
subject_test <- read.table(file.path(pathdata, "test", "subject_test.txt"))
xtrain <- read.table(file.path(pathdata, "train", "X_train.txt"))
ytrain <- read.table(file.path(pathdata, "train", "y_train.txt"))
subject_train <- read.table(file.path(pathdata, "train", "subject_train.txt"))
features <- read.table(file.path(pathdata, "features.txt"))
activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"))

#putting names to each colum#
colnames(xtest) <- features[,2]
colnames(ytest) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(xtrain) <- features[,2]
colnames(ytrain) <- "activityId"
colnames(subject_train) <- "subjectId"
colnames(activityLabels) <- c("activityId","activityType")

#marging the files#
trainmarge <- cbind(ytrain, subject_train, xtrain)
testmarge <- cbind(ytest, subject_test, xtest)
setAllInOne <- rbind(trainmarge, testmarge)

#load dplyr and select mean and standard deviation from the colums#
library(dplyr)
mean_deviation <- setAllInOne %>% select(contains("activityId") | contains("subjectId") | contains("mean") | contains("std"))

#get descriptive names from each column#
DescriptiveNames <- merge(activityLabels, mean_deviation, by="activityId")
names(DescriptiveNames)<-gsub("Acc", "Accelerometer", names(DescriptiveNames))
names(DescriptiveNames)<-gsub("Gyro", "Gyroscope", names(DescriptiveNames))
names(DescriptiveNames)<-gsub("BodyBody", "Body", names(DescriptiveNames))
names(DescriptiveNames)<-gsub("Mag", "Magnitude", names(DescriptiveNames))
names(DescriptiveNames)<-gsub("^t", "Time", names(DescriptiveNames))
names(DescriptiveNames)<-gsub("^f", "Frequency", names(DescriptiveNames))
names(DescriptiveNames)<-gsub("tBody", "TimeBody", names(DescriptiveNames))
names(DescriptiveNames)<-gsub("-mean()", "Mean", names(DescriptiveNames), ignore.case = TRUE)
names(DescriptiveNames)<-gsub("-std()", "STD", names(DescriptiveNames), ignore.case = TRUE)
names(DescriptiveNames)<-gsub("-freq()", "Frequency", names(DescriptiveNames), ignore.case = TRUE)
names(DescriptiveNames)<-gsub("angle", "Angle", names(DescriptiveNames))
names(DescriptiveNames)<-gsub("gravity", "Gravity", names(DescriptiveNames))

#create a independent data set with the average of each variable for each activity and each subject#
tidyData <- aggregate(DescriptiveNames$subjectId + DescriptiveNames$activityId, DescriptiveNames, mean)
tidyData <- tidyData[order(tidyData$subjectId,tidyData$activityId),]
write.table(tidyData, file = "tidyData.txt", row.names = FALSE)
