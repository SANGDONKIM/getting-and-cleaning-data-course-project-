setwd("C:/Users/sangdon/Desktop/datasciencecoursera/getting and cleaning data/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
library(tidyverse)

features <- read.table("features.txt", as.is = T, header = F)
activitylabels <- read.table("activity_labels.txt", col.names = c("act_id", "act_label")) 
# as.is=T : don't convert text labels to factors


# test data
test_subject <- read.table("./test/subject_test.txt", header = F)
test_values <- read.table("./test/X_test.txt", header = F)
test_activity <- read.table("./test/y_test.txt", header = F)

# train data
train_subject <- read.table("./train/subject_train.txt", header = F)
train_values <- read.table("./train/X_train.txt", header = F)
train_activity <- read.table("./train/y_train.txt", header = F)


datasubject <- rbind(train_subject, test_subject)
datavalues <- rbind(train_values, test_values)
dataactivity <- rbind(train_activity, test_activity)

names(datasubject) <- c("subject")
names(dataactivity) <- c("activity")
names(datavalues) <- features$V2

mergedata1 <- cbind(datasubject, dataactivity)
mergedata <- cbind(datavalues, mergedata1)

str(mergedata)
names(mergedata)

subnames<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
selectednames<-c(as.character(subnames), "subject", "activity")
tidydata<-subset(mergedata,select=selectednames)

str(tidydata)
names(tidydata)


names(tidydata)<-gsub("^t", "time", names(tidydata))
names(tidydata)<-gsub("^f", "frequency", names(tidydata))
names(tidydata)<-gsub("Acc", "Accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))

names(tidydata)

Data <- aggregate(.~subject+activity, tidydata, mean)
Data <- Data[order(Data$subject, Data$activity), ]
write.table(Data, file="C:/Users/sangdon/Desktop/getting-and-cleaning-data-course-project-/tidydata.txt", 
            row.names = F, quote = F)
