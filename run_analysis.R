
#Read 
activity_labels <- read.table("~/R/week4/UCI HAR Dataset/activity_labels.txt")
features <- read.table("~/R/week4/UCI HAR Dataset/features.txt")

activity_labels[,2] <- as.character(activity_labels[,2])
features[,2]<- as.character(features[,2])

SelectedFeatures <- grep(".*mean.*|.*std.*",features[,2])
SelectedFeatures.Desp <- features[SelectedFeatures,2]
#SelectedFeatures.Desp

x_train <- read.table("~/R/week4/UCI HAR Dataset/train/X_train.txt")[SelectedFeatures]
y_train <- read.table("~/R/week4/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("~/R/week4/UCI HAR Dataset/train/subject_train.txt")

train <- cbind(x_train,y_train,subject_train)


x_test <- read.table("~/R/week4/UCI HAR Dataset/test/X_test.txt")[SelectedFeatures]
y_test <- read.table("~/R/week4/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("~/R/week4/UCI HAR Dataset/test/subject_test.txt")

test <- cbind(x_train,y_train,subject_train)

test_train <- rbind(train,test)
colnames(test_train) <- c("subject", "activity", SelectedFeatures.Desp)


#?factor
test_train$activity <-factor(test_train$activity, levels = activity_labels[,1], labels = activity_labels[,2])
test_train$subject <- as.factor(test_train$subject)

head(test_train)

test_train.melted <- melt(test_train, id = c("subject", "activity"))
test_train.melted

test_train.mean <- dcast(test_train.melted, subject + activity ~ variable, mean)
write.table(test_train.mean, "~/R/week4/UCI HAR Dataset/tidyData.txt", row.names = FALSE, quote = FALSE)
