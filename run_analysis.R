# loading data.table library for faster processing
library(data.table)
# for joining tables
library(plyr)
# for melting
library(reshape2)

## PART 1
# loading col names
features <- read.table("features.txt", header=FALSE)
# create header vector
head <- c("FeatureID", as.character(features$V2))
# test data
# load test features list
test_feat <- read.table("test//y_test.txt", header=FALSE)
names(test_feat) <- c("VF")
# load test data file
test_data <- read.table("test//X_test.txt", header=FALSE)
# create test data
test <- cbind(test_feat, test_data)

# train data
# load train data file
train_data <- read.table("train//X_train.txt", header=FALSE)
# load train features list
train_feat <- read.table("train//y_train.txt", header=FALSE)
names(train_feat) <- c("VF")

# create train data
train <- cbind(train_feat, train_data)

# merged data
all_data <- rbind(test, train)

return(all_data)

## PART 4
# append a header
names(all_data) <- head

## PART 3
# load list of activities
act_lab <- read.table("activity_labels.txt", header=FALSE)
names(act_lab) <- c("FeatureID","Feature")

# merge with descriptive activities
act_desc <- join(all_data, act_lab, by="FeatureID")
# remove feature id column
act_desc <- subset(act_desc, select = -FeatureID)


## PART 2
# initialize empty variable
#header <- c("Feature")
header <- c()
# roll over all columns
for (feat in names(all_data)) {
        if ( grepl("std",feat) | grepl("mean",feat) )  {
                # only std and mean should be included
                header <- c(header,feat)
        }
}

# put only std and mean variables
tidy_data <- subset(act_desc, select = c("Feature",header))

## PART 5
# melting with respect to feature
melt_ms_data <- melt(tidy_data, id=c("Feature"), measure.vars=c(header))
# tidy data set of mean for all subjects
tidy_data_mean <- dcast(melt_ms_data, Feature ~ variable, mean)
# export 
file <- "tidy_data.txt"
write.table(tidy_data_mean, file=file, row.name=FALSE)