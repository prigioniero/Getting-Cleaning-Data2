#merge dataset
setwd("C:/Users/sdigregorio/Documents/Progetti/coursera/UCI HAR Dataset/")


#############READ DATA ######################
traing_set <- read.table("./train/X_train.txt")
traing_lbl <- read.table("./train/y_train.txt")
traing_subject <- read.table("./train/subject_train.txt")

test_set <- read.table("./test/X_test.txt")
testlabel <- read.table("./test/y_test.txt")
test_subject <- read.table("./test/subject_test.txt")
##############################################

###############MERGE##########################
merged_data <- rbind(traing_set, test_set)
merged_lbl <- rbind(traing_lbl, testlabel)
merged_subject <- rbind(traing_subject, test_subject)


########descriptive var names#############
features <- read.table("./features.txt")
c_names <- features[,2]

colnames(merged_data) <- c_names
colnames(merged_lbl) <- "activity_id"
colnames(merged_subject) <- "subject_id"
####OK#####

data_appo <- cbind(merged_subject , merged_lbl , merged_data)
data_all <- data_appo[order(data_appo$subject_id,data_appo$activity_id),]



######activity descr#######
activity <- read.table("./activity_labels.txt",col.names=c("activity_id","activity"))
library(plyr)
data<- join(data_all,activity,by='activity_id')


#extract only mean stD #
col <- grep("mean()|std()",names(data),ignore.case=TRUE,value=TRUE)
extraction<- data[,c("subject_id","activity_id","activity",col)]

# data set w/ average foreach var foreach activity foreach subject #
##########################################################################################
library(reshape2)
data_melt<-melt(extraction,id=c("subject_id","activity"), measure.vars=col)
tidy_final <- dcast(data_melt, subject_id + activity ~ variable,mean)

colnames(tidy_final)<- c("subject_id","activity",paste("Mean of",col))
write.table(tidy_final,"./tidy_final.txt", quote=F ,sep="," , row.name=FALSE)






