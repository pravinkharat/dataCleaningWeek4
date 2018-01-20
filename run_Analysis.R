
#Read 
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

activity_labels[,2] <- as.character(activity_labels[,2])
features[,2]<- as.character(features[,2])

SelectedFeatures <- grep(".*mean.*|.*std.*",features[,2])
SelectedFeatures.Desp <- features[SelectedFeatures,2]
SelectedFeatures.Desp = gsub('-mean', 'Mean', SelectedFeatures.Desp)
SelectedFeatures.Desp = gsub('-std', 'Std', SelectedFeatures.Desp)
SelectedFeatures.Desp <- gsub('[-()]', '', SelectedFeatures.Desp)

#SelectedFeatures.Desp

x_train <- read.table("train/X_train.txt")[SelectedFeatures]
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

train <- cbind(subject_train,y_train,x_train)


x_test <- read.table("test/X_test.txt")[SelectedFeatures]
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

test <- cbind(subject_test,y_test,x_test)

test_train <- rbind(train,test)
colnames(test_train) <- c("subject", "activity", SelectedFeatures.Desp)


#?factor
test_train$activity <-factor(test_train$activity, levels = activity_labels[,1], labels = activity_labels[,2])
test_train$subject <- as.factor(test_train$subject)

head(test_train)

test_train.melted <- melt(test_train, id = c("subject", "activity"))
test_train.melted

test_train.mean <- dcast(test_train.melted, subject + activity ~ variable, mean)
write.table(test_train.mean, "~/tidyData.txt", row.names = FALSE, quote = FALSE)
