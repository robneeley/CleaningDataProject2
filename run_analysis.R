library(dplyr)

## declare file paths
trainfpaths <- list("train/X_train.txt", "train/Y_train.txt", "train/subject_train.txt")
testfpaths <- list("test/X_test.txt", "test/Y_test.txt", "test/subject_test.txt")
featfpath <- "features.txt"
activityfpath <- "activity_labels.txt"



## read files

features <- read.table(featfpath, col.names= c("featureid", "feature"))
activities <- read.table(activityfpath ,col.names=c("activityid", "activity"), stringsAsFactors=F)


## read training files
ytrain <- read.table(trainfpaths[[2]], col.names=c("activityid"))             
xtrain <- read.table(trainfpaths[[1]])
trainsubject <- read.table(trainfpaths[[3]], col.names=c("subject"))

## read test files
ytest <- read.table(testfpaths[[2]], col.names= c("activityid") )             
xtest <- read.table(testfpaths[[1]])
testsubject <- read.table(testfpaths[[3]],  col.names=c("subject"))

## investigate structures
str(xtest)
str(ytest)
str(testsubject)

str(xtrain)
str(ytrain)
str(trainsubject)

str(features)
str(activities)

str(xtest)

## start creating the full dataset by joining the activityid on the datatables
xtest <- c(xtest, ytest, testsubject)
xtrain <- c(xtrain, ytrain, trainsubject)
names(xtest)

intersect(names(xtest), names(activities))
intersect(names(xtrain), names(activities))

x<- merge(xtrain, activities, by="activityid")
y <- merge(xtest, activities, by="activityid")
names(x)
names(y)

#remove extra activity id column from both tables
#it's in the first position aftr the merge
x <- x[, 2:length(x)]
y <- y[, 2:length(y)]

##evaluate structure
str(x)
str(y)

## create the master data set and label the variables
headernames <- c(as.character(features$feature),"subject",  "activity")
dataset <- rbind(x, y)
colnames(dataset) <- headernames

## confirm names are correct
colnames(dataset)

##datasetis now properly labeled

## filter the records down to mean and standard deviation
## columns using regular expressions
fdata <- dataset[, grep("(std|mean|activity|subject)", colnames(dataset)) ]

nrow(fdata)
##inspect columns
names(fdata)
head(fdata, 1)

tidyData <- fdata  %>%  group_by_(.dots = c("activity", "subject"))  %>%  summarise_each(funs(mean))
  
print(tidyData)



