"Getting and Cleaning Data" Course Project (Frank Hecker)
=========================================================

Summary
-------

The course project for the "Getting and Cleaning Data" course creates
a data set based on an analysis of the "Human Activity Recognition
Using Smartphones Dataset, Version 1.0" \[1\]. The data in the
original data set is from 30 subjects, each performing six activities
while wearing a smartphone equipped with an accelerometer and
gyroscope.

The data used from the original data set contains a total of 561
variables wth values for each combination of subject and
activity. (For a description of the original variables see the file
`README.txt` included with the original data set.)

The analysis for this project selects a subset of the 561 variables,
computes their means for each combination of subject and activity, and
produces an output data set containing those means in "tidy" format
\[2\].

More specifically, the five steps of the analysis are as follows:

1. Merge the data from the original training and test data sets.
2. Extract only the variables representing mean and standard deviation
measurements.
3. Replace the activity numeric codes with the activity labels.
4. Use descriptive variable names.
5. Create a second, independent tidy data set with the average of
each variable for each activity and each subject.

See below for more information on these processing steps.

Processing the Original Data
----------------------------

As unpacked the original data set consists of a directory `UCI HAR
Dataset` containing two groups of files, one with training data (in
the `train` subdirectory) and one with test data (in the `test`
subdirectory). Each group in turn contains three files, containing the
subject ids (`subject_train.txt` or `subject_test.txt` respectively),
activity codes (`y_train.txt` or `y_test.txt`), and the measurements
themselves (`X_train.txt` or `X_test.txt`). Each row in each of the
three files corresponds to a single sample of the 561 variables for a
given subject and activity.

The original data set also contains separate files mapping the
activity codes to activity labels (`activity_labels.txt`) and mapping
the variable column indices (from 1 to 561) in `X_train.txt` and
`X_test.txt` to the corresponding variable names (`features.txt`).

Finally, the original training and test data sets also contain
`Inertial Signals` subdirectories with additional raw data. These were
not included in the analysis.

All the data files mentioned above were used to produce six data sets,
corresponding to the two groups of three data files discussed
above. These data sets were then combined to produce one master data
set containing all the raw data (with the exception of the `Inertial
Signals` data, as noted above). The columns of this data set included
the subject id, activity code, and the 561 variables; the rows
included all observations from the training and test data sets.

Selecting Variables for Analysis
--------------------------------

As noted above, the original data set contains 561 separate variables
(not counting the subject and activity codes). The course project
description is somewhat ambiguous in its discussion of which "mean"
and "standard deviation" variables to extract for further analysis.

Of the 561 variables, 79 variables have either "mean" or "std" in
their names. However not all of them appear to be appropriate for
inclusion in the analysis. For example, the `fBodyAcc-*` group of
variables inclues variables `fBodyAcc-mean()-X`, `fBodyAcc-mean()-Y`,
`fBodyAcc-mean()-Z`, wih corresponding standard deviation variables
`fBodyAcc-std()-X`, `fBodyAcc-std()-Y`, and
`fBodyAcc-std()-Z`. However the `fBodyAcc` group also includes
variables `fBodyAcc-meanFreq()-X`, `fBodyAcc-meanFreq()-Y`, and
`fBodyAcc-meanFreq()-Z` that have no corresponding standard deviation
variables. This analysis omits variables representing means without
corresponding standard deviations, which brings the total number of
selected variables down to 66.

Another issue is that some mean and standard deviation variables do
not have individual X, Y, or Z components. For example, the
`tBodyAccMag-*` group of variables includes `tBodyAccMag-mean()` and
`tBodyAccMag-std()`; since these are based on the magnitudes (i.e.,
lengths) of the corresponding 3-dimensional vectors by definition they
will not have X, Z, or Z components. There are 18 variables of this
type; this analysis includes them all as part of the 66 selected
variables.

See below for a list of the variables selected for analysis and their
descriptions.

Adding Activity Labels and Descriptive Variable Names
-----------------------------------------------------

The activity numeric codes in the data (with values from 1 to 6) were
replaced by the activity labels (from `activity_labels.txt`).

Descriptive variable names were created based on the variable names in
the original data set (from `features.txt`). The original variable
names were modified slightly in order to make the new names usable as
standard R variable identifiers, with no spaces, parentheses removed,
and hyphens replaced with underscores. Thus, for example, for the
original variable `tBodyAcc-mean()-X` the descriptive name used is
`tBodyAcc_mean_X`.

Creating the Tidy Data Set
--------------------------

The analysis script produces a "narrow" tidy set, with each row
corresponding to a given combination of subject, activity, and
variable. For example, there is one row containing the mean value of
all observations in the original data set for the variable
"tBodyAcc-std()-X" (standard deviation of body linear acceleration in
the direction of the X axis) for subject 3 while walking.

This final data set is produced by first melting the data set produced
by step 4 of the analysis (i.e., containing only the mean and standard
deviation measurements), using subject and activity as id
variables. This takes a row containing the columns for the multiple
measurements produced for a given subject and activity and produces
multiple rows in the melted data set, one row for each measurement for
that subject and activity. The melted data set has four columns,
corresponding to the subject, activity, (type of) measurement, and
measured value.

This melted data set is then used to produce the final tidy data set,
by taking all rows for a given subject/activity/measurement and
computing the mean of the measured values. The final tidy data set
also has four columns, corresponding to the subject, activity, (type
of) measurement, and mean of the measured values.

Assuming that there was complete coverage of all subjects and
activities, the tidy set should contain 11,880 rows, corresponding to
30 subjects, 6 activities, and 66 variables.

The final tidy data set is written to disk as a text file using
`write.table`, with one line per row and the values for each row
separated by spaces. The output file can be read into R using
`read.table`.

Format of the Tidy Data Set
---------------------------

The columns in the final tiny data set (and the corresponding output
file) are as follows:

* Subject: An integer identifying the subject, with values from 1
  to 30.
* Activity: A character string identifying the activity, with possible
  values as follows:
    * WALKING
    * WALKING_UPSTAIRS
    * WALKING_DOWNSTAIRS
    * SITTING
    * STANDING
    * LAYING
* Measurement: A character string identifying the measured variable,
  with possible values as listed below.
* Mean: A numeric value that is the mean of all values for the
  measured variable for the subject and activity in question.

The variables (in the third column) for which means were calculated
(in the fourth column) are as follows; the names are based on the
variable names in the original data set, as discussed above:

* tBodyAcc_mean_X: Mean of body linear acceleration in the X direction.
* tBodyAcc_mean_Y: Mean of body linear acceleration in the Y direction.
* tBodyAcc_mean_Z: Mean of body linear acceleration in the Z direction.
* tBodyAcc_std_X: Standard deviation of body linear acceleration in
  the X direction.
* tBodyAcc_std_Y: Standard deviation of body linear acceleration in
  the Y direction.
* tBodyAcc_std_Z: Standard deviation of body linear acceleration in
  the Z direction.
* tGravityAcc_mean_X: Mean of gravity acceleration in the X direction.
* tGravityAcc_mean_Y: Mean of gravity acceleration in the Y direction.
* tGravityAcc_mean_Z: Mean of gravity acceleration in the Z direction.
* tGravityAcc_std_X: Standard deviation of gravity acceleration in the
  X direction.
* tGravityAcc_std_Y: Standard deviation of gravity acceleration in the
  Y direction.
* tGravityAcc_std_Z: Standard deviation of gravity acceleration in the
  Z direction.
* tBodyAccJerk_mean_X: Mean of body linear acceleration jerk signal in
  the X direction.
* tBodyAccJerk_mean_Y: Mean of body linear acceleration jerk signal in
  the Y direction.
* tBodyAccJerk_mean_Z: Mean of body linear acceleration jerk signal in
  the Z direction.
* tBodyAccJerk_std_X: Standard deviation of body linear acceleration
  jerk signal in the X direction.
* tBodyAccJerk_std_Y: Standard deviation of body linear acceleration
  jerk signal in the Y direction.
* tBodyAccJerk_std_Z: Standard deviation of body linear acceleration
  jerk signal in the Z direction.
* tBodyGyro_mean_X: Mean of body angular velocity in the X direction.
* tBodyGyro_mean_Y: Mean of body angular velocity in the Y direction.
* tBodyGyro_mean_Z: Mean of body angular velocity in the Z direction.
* tBodyGyro_std_X: Standard deviation of body angular velocity in the
  X direction.
* tBodyGyro_std_Y: Standard deviation of body angular velocity in the
  Y direction.
* tBodyGyro_std_Z: Standard deviation of body angular velocity in the
  Z direction.
* tBodyGyroJerk_mean_X: Mean of body angular velocity jerk signal in
  the X direction.
* tBodyGyroJerk_mean_Y: Mean of body angular velocity jerk signal in
  the Y direction.
* tBodyGyroJerk_mean_Z: Mean of body angular velocity jerk signal in
  the Z direction.
* tBodyGyroJerk_std_X: Standard deviation of body angular velocity
  jerk signal in the X direction.
* tBodyGyroJerk_std_Y: Standard deviation of body angular velocity
  jerk signal in the Y direction.
* tBodyGyroJerk_std_Z: Standard deviation of body angular velocity
  jerk signal in the Z direction.
* fBodyAcc_mean_X: Mean of FFT results for body linear acceleration in
  the X direction.
* fBodyAcc_mean_Y: Mean of FFT results for body linear acceleration in
  the Y direction.
* fBodyAcc_mean_Z: Mean of FFT results for body linear acceleration in
  the Z direction.
* fBodyAcc_std_X: Standard deviation of FFT results for body linear
  acceleration in the X direction.
* fBodyAcc_std_Y: Standard deviation of FFT results for body linear
  acceleration in the Y direction.
* fBodyAcc_std_Z: Standard deviation of FFT results for body linear
  acceleration in the Z direction.
* fBodyAccJerk_mean_X: Mean of FFT results for body linear
  acceleration jerk signal in the X direction.
* fBodyAccJerk_mean_Y: Mean of FFT results for body linear
  acceleration jerk signal in the Y direction.
* fBodyAccJerk_mean_Z: Mean of FFT results for body linear
  acceleration jerk signal in the Z direction.
* fBodyAccJerk_std_X: Standard deviation of FFT results for body
  linear acceleration jerk signal in the X direction.
* fBodyAccJerk_std_Y: Standard deviation of FFT results for body
  linear acceleration jerk signal in the Y direction.
* fBodyAccJerk_std_Z: Standard deviation of FFT results for body
  linear acceleration jerk signal in the Z direction.
* fBodyGyro_mean_X: Mean of FFT results for body angular velocity in
  the X direction.
* fBodyGyro_mean_Y: Mean of FFT results for body angular velocity in
  the Y direction.
* fBodyGyro_mean_Z: Mean of FFT results for body angular velocity in
  the Z direction.
* fBodyGyro_std_X: Standard deviation of FFT results for body angular
  velocity in the X direction.
* fBodyGyro_std_Y: Standard deviation of FFT results for body angular
  velocity in the Y direction.
* fBodyGyro_std_Z: Standard deviation of FFT results for body angular
  velocity in the Z direction.
* tBodyAccMag_mean: Mean of the magnitude of the three-dimensional
  body linear acceleration signals.
* tBodyAccMag_std: Standard deviation of the magnitude of the
  three-dimensional body linear acceleration signals.
* tGravityAccMag_mean: Mean of the magnitude of the three-dimensional
  gravity acceleration signals.
* tGravityAccMag_std: Standard deviation of the magnitude of the
  three-dimensional gravity acceleration signals.
* tBodyAccJerkMag_mean: Mean of the magnitude of the three-dimensional
  body linear acceleration jerk signals.
* tBodyAccJerkMag_std: Standard deviation of the magnitude of the
  three-dimensional body linear acceleration jerk signals.
* tBodyGyroMag_mean: Mean of the magnitude of the three-dimensional
  body angular velocity signals.
* tBodyGyroMag_std: Standard deviation of the magnitude of the
  three-dimensional body angular velocity signals.
* tBodyGyroJerkMag_mean: Mean of the magnitude of the
  three-dimensional body angular velocity jerk signals.
* tBodyGyroJerkMag_std: Standard deviation of the magnitude of the
  three-dimensional body angular velocity jerk signals.
* fBodyAccMag_mean: Mean of magnitude of FFT results for body linear
  acceleration.
* fBodyAccMag_std: Standard deviation of magnitude of FFT results for
  body linear acceleration.
* fBodyBodyAccJerkMag_mean: Mean of magnitude of FFT results for body
  linear acceleration jerk signals.
* fBodyBodyAccJerkMag_std: Standard deviation of magnitude of FFT
  results for body linear acceleration jerk signals.
* fBodyBodyGyroMag_mean: Mean of magnitude of FFT results for body
  angular velocity.
* fBodyBodyGyroMag_std:: Standard deviation of magnitude of FFT
  results for body angular velocity.
* fBodyBodyGyroJerkMag_mean:: Mean of magnitude of FFT results for
  body angular velocity jerk signals.
* fBodyBodyGyroJerkMag_std: Standard deviation of magnitude of FFT
  results for body angular velocity jerk signals.

The original `features_info.txt` file does not explicitly specify the
units for the measurements. In general measurements of acceleration
would be given as m/s^2 (meters per second squared) and measurments of
velocity as m/s (meters per second); whether or not this is true in
the case of the original data set is unclear.

\[1\] "Human Activity Recognition Using Smartphones Dataset, Version
1.0", Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, and Luca
Oneto, Smartlab - Non Linear Complex Systems Laboratory, DITEN -
UniversitÃ degli Studi di
Genova. [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
(dataset itself at
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI\%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI\%20HAR%20Dataset.zip))

\[2\] "Tidy Data", Hadley Wickham, RStudio. [http://vita.had.co.nz/papers/tidy-data.pdf](http://vita.had.co.nz/papers/tidy-data.pdf)
