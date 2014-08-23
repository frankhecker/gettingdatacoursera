# run_analysis.R

# Load any required packages not in base R.
#
# NOTE: This assumes the packages are already installed.

message("Loading required packages")
library("reshape2")
library("plyr")

# Set locations and paths for the raw data.
#
# NOTE: We assume Unix-style pathnames.

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

# Download the original data set (if not already downloaded) and unzip
# it into the working directory (if not already unzipped).

if (!file.exists(zip_file)) {
  message("Downloading data")
  download.file(data_url, zip_file, method="curl")
}
if (!file.exists(data_dir)) {
  message("Unzipping data")
  unzip(zip_file)
}

# Read in the raw data from the original data set.

message("Reading data")
X_train_df <- read.table(X_train_file)
X_test_df <- read.table(X_test_file)

# Read in the corresponding activity and subject values.

y_train_df <- read.table(y_train_file)
y_test_df <- read.table(y_test_file)
subject_test_df <- read.table(subject_test_file)
subject_train_df <- read.table(subject_train_file)

# Read in the list of features (i.e., the variable names for the
# original data) and the activity labels.

features_df <- read.table(features_file, stringsAsFactors=FALSE)
labels_df <- read.table(labels_file, stringsAsFactors=FALSE)

# Perform some basic integrity checks on the data:
#
# * The training and test data sets should have the same number of
#   variables (columns).
#
# * The data values, the subject values, and the activity values
#   should all have the same number of observations (rows).

message("Checking data")
if (ncol(X_train_df) != ncol(X_test_df)) stop("training/test mismatch")
if (nrow(X_train_df) != nrow(subject_train_df)) stop("training data/subject mismatch")
if (nrow(X_test_df) != nrow(subject_test_df)) stop("test data/subject mismatch")
if (nrow(X_train_df) != nrow(y_train_df)) stop("training data/activity mismatch")
if (nrow(X_test_df) != nrow(y_test_df)) stop("test data/activity mismatch")

# STEP 1: "Merges the training and the test sets to create one data set."
#
# First join the three training data sets into one data set (combining
# columns), and likewise for the test data sets. Then combine the
# resulting two data sets into one data set (combining rows).

message("Merging data (step 1)")
train_df <- cbind(subject_train_df, y_train_df, X_train_df)
test_df <- cbind(subject_test_df, y_test_df, X_test_df)
combined_df <- rbind(train_df, test_df)

# STEP 2: "Extracts only the measurements [of] the mean and standard
# deviation for each measurement."
#
# Find the subset of variables that represent means and standard
# deviations of raw measurements in the X, Y, and Z directions (e.g.,
# "tBodyAcc-mean()-X").  Exclude variables based on FFT calculations
# (e.g., "fBodyAcc-mean()-X"), as well as those based on calculated
# magnitudes (e.g., "tBodyAccMag-mean()").  The subset is identified
# by the indices identifying the position of those variables within
# the overall list of variables.
#
# NOTE: We use '\\' in the regular expression instead of '\' because
# we need to escape the backslash character from R's string parsing.

message("Extracting mean and standard deviation data (step 2)")
meanstd_indices <- grep("^t.*-(mean|std)\\(\\)-(X|Y|Z)$", features_df$V2)

# Create a new data set containing only these means and standard deviations,
# as well as the first two columns (subject and activity) carried over from
# the original data set.
#
# NOTE: The "+2" is because the first variable in the list of variables is
# actually in the third column of the original data set.

meanstd_df <- combined_df[, c(1, 2, meanstd_indices+2)]

# STEP 3: "Uses descriptive activity names to name the activities in
# the data set."
#
# Replace the activity numeric codes in the second column of the
# combined data set with the activity label strings corresponding to
# those numeric codes.

message("Labelling activities (step 3)")
meanstd_df[, 2] <- labels_df$V2[meanstd_df[, 2]]

# STEP 4: "Appropriately labels the data set with descriptive variable
#  names."
#
# Find the names of the variables containing the means and standard
# deviations and convert them into valid R variable names by removing
# the parentheses and changing hyphens to underscores.

message("Labelling variables (step 4)")
meanstd_varnames <- features_df$V2[meanstd_indices]
meanstd_varnames <- gsub("\\(\\)", "", meanstd_varnames)
meanstd_varnames <- gsub("-", "_", meanstd_varnames)

# Replace the column names of the combined data set with more
# descriptive names, including the variable names just computed.

colnames(meanstd_df) <- c("Subject", "Activity", meanstd_varnames)

# STEP 5. "Creates a second, independent tidy data set with the
# average of each variable for each activity and each subject."
#
# First, melt meanstd_df so that the columns representing the measured
# variables are converted into rows representing individual
# observations.  Each row of the resulting melted data set will have
# four columns, corresponding to a single measured value for a given
# combination of subject, activity, and type of measurement.

message("Tidying data (step 5)")
melted_df <- melt(meanstd_df,
                  id=c("Subject", "Activity"),
                  variable.name="Measurement",
                  value.name="Value")

# Next, summarize the data by taking the means of each combination of
# subject, activity, and type of measurement. This produces a new data
# set with the Value column replaced by a new column Mean
# corresponding to the mean value for a given combination of subject,
# activity, and type of measurement.

tidy_df <- ddply(melted_df,
                 .(Subject, Activity, Measurement),
                 summarize,
                 Mean = mean(Value))

# Write the tidy data set to a file for submission.

message("Writing tidy data file")
write.table(tidy_df, "tidy_data.txt", quote=FALSE, row.names=FALSE)
