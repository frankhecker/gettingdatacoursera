# run_analysis.R

# Locations and paths for the raw data.
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_dir <- "UCI HAR Dataset"
zip_file <- "uci-har-dataset.zip"
X_train_file <- paste(data_dir, "/train/X_train.txt", sep="")
X_test_file <- paste(data_dir, "/test/X_test.txt", sep="")
y_train_file <- paste(data_dir, "/train/y_train.txt", sep="")
y_test_file <- paste(data_dir, "/test/y_test.txt", sep="")
subject_train_file <- paste(data_dir, "/train/subject_train.txt", sep="")
subject_test_file <- paste(data_dir, "/test/subject_test.txt", sep="")
features_file <- paste(data_dir, "/features.txt", sep="")
labels_file <- paste(data_dir, "/activity_labels.txt", sep="")

# Get and extract the dataset into the working directory if not already present.
if (!file.exists(zip_file)) download.file(data_url, zip_file, method="curl")
if (!file.exists(data_dir)) unzip(zip_file)

# Read in the raw measured data.
X_train_df <- read.table(X_train_file)
X_test_df <- read.table(X_test_file)

# Read in the corresponding activity and subject values.
y_train_df <- read.table(y_train_file)
y_test_df <- read.table(y_test_file)
subject_test_df <- read.table(subject_test_file)
subject_train_df <- read.table(subject_train_file)

# Get the list of features (i.e., the variables for the measured data) and
# the activity labels.
features_df <- read.table(features_file, stringsAsFactors=FALSE)
labels_df <- read.table(labels_file, stringsAsFactors=FALSE)

# Perform some integrity checks on the data:
# * The training and test measured data should have the same number of
#   variables (columns).
# * The measured data, the subject values, and the activity values should all
#   have the same number of samples (rows).
if (ncol(X_train_df) != ncol(X_test_df)) stop("training/test mismatch")
if (nrow(X_train_df) != nrow(subject_train_df)) stop("training data/subject mismatch")
if (nrow(X_test_df) != nrow(subject_test_df)) stop("test data/subject mismatch")
if (nrow(X_train_df) != nrow(y_train_df)) stop("training data/activity mismatch")
if (nrow(X_test_df) != nrow(y_test_df)) stop("test data/activity mismatch")

# STEP 1: "Merges the training and the test sets to create one data set."
#
# First join the various training datasets into one dataset, and likewise for
# the test datasets. Then combine the resulting datasets into one dataset.
train_df <- cbind(subject_train_df, y_train_df, X_train_df)
test_df <- cbind(subject_test_df, y_test_df, X_test_df)
combined_df <- rbind(train_df, test_df)

# STEP 2: "Extracts only the measurements [of] the mean and standard deviation
# for each measurement."
#
# Find the subset of variables that represent means and standard deviations of
# raw measurements in the X, Y, and Z directions (e.g., "tBodyAcc-mean()-X").
# We exclude variables based on FFT calculations (e.g., "fBodyAcc-mean()-X"),
# as well as those based on calculated magnitudes (e.g., "tBodyAccMag-mean()").
meanstd_indices <- grep("^t.*-(mean|std)\\(\\)-(X|Y|Z)$", features_df$V2)

# Create a new data set containing only these means and standard deviations.
meanstd_df <- combined_df[, c(1, 2, meanstd_indices+3)]

# STEP 3: "Uses descriptive activity names to name the activities in the data
# set."
#
# Replace the activity numeric codes in the second column of the combined
# dataset with the activity label strings corresponding to those numeric codes.
meanstd_df[, 2] <- labels_df$V2[meanstd_df[, 2]]

# STEP 4: "Appropriately labels the data set with descriptive variable names."
#
# Find the names of the variables containing the means and standard deviations
# and convert them into valid R variable names by removing the parentheses and
# changing hyphens to underscores.
meanstd_varnames <- features_df$V2[meanstd_indices]
meanstd_varnames <- gsub("\\(\\)", "", meanstd_varnames)
meanstd_varnames <- gsub("-", "_", meanstd_varnames)

# Replace the column names of the combined dataset with more descriptive names,
# including the variable names just computed.
colnames(meanstd_df) <- c("Subject", "Activity", meanstd_varnames)

# STEP 5. "Creates a second, independent tidy data set with the average of each
# variable for each activity and each subject."
#
# To be written.
