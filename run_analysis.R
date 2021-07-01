#setting work directory#
pathdata <- file.path("C:/Users/manue/Desktop/UCI HAR Dataset/")

#get all files in a list#
files <- list.files(pathdata, recursive=TRUE)

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
DescriptiveNames = merge(mean_deviation, activityLabels, by="activityId")
DescriptiveNames
