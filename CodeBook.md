Tidy Data Set for "Getting and Cleaning Data" Course Project
============================================================

Summary
-------

The original data set for the course project is the "Human Activity
Recognition Using Smartphones Dataset, Version 1.0" \[1\]. The
raw data is from 30 subjects, each performing six activities while
wearing a smartphone equipped with an accelerometer and gyroscope.

The raw data contains a total of 561 variables measured (or, in some
cases, calculated) for each combination of subject and activity. (For
a description of the original variables see the file `README.txt`
included with the original data set.)

The analysis for this project selects a subset of the 561 variables,
computes their means for each combination of subject and activity, and
produces an output data set containing those means in "tidy" format
\[2\].

The Original Data Sets
---------------------------------

The original data sets consist of two groups of files, one with
training data (in the `train` subdirectory) and one with test data (in
the `test` subdirectory). Each group in turn contains three files,
containing the subject ids (`subject_train.txt` or `subject_test.txt`
respecitvely), activity codes (`y_train.txt` or `y_test.md`), and the
measurements themselves (`X_train.txt` or `X_test.txt`). Each row in
each of the three files corresponds to a single sample of the 561
variables for a given subject and activity.

The original data sets also contain separate files mapping activity
codes to activity labels (`activity_labels.txt`) and mapping the
variable column indices (from 1 to 561) in `X_train.txt` and
`X_test.txt` to the corresponding variable names (`features.txt`).

Finally, the original data sets also contain `Inertial Signals`
subdirectories with additional raw data. This data was not included in the
analysis for the course project.

Processing the Original Data
----------------------------

All the data files mentioned above were used to produce six data sets,
corresponing to the two groups of three data file noted above. These
data sets were then combined to produce one master data set containing
all the raw data (with the exception of the `Inertial Signals` data,
as noted above). The columns of this data set included the subject id,
activity code, and the 561 variables; the rows included all
obervations from the training and test data sets.

Selecting Variables for Analysis
--------------------------------

As noted above, the original data sets contain 561 separate variables
(not counting the subject and activity codes). The course project
description is somewhat ambiguous in its discussion of which "mean"
and "standard deviation" variables to extract for further analysis.

Of the 561 variables, 79 variables have either "mean" or "std" in
their names. However not all of them appear to be appropriate for
inclusion in the analysis: In particular, many of the variables do not
represent original memeasurements but rather are variables derived in
some way from the original measurements. The analysis script is
conservative in terms of which variables to include; it reflects the
following decisions:

* Include variables that represent means and standard deviations of
raw measurements in the X, Y, and Z directions (e.g.,
`tBodyAcc-mean()-X`).
* Exclude variables based on FFT calculations (e.g., `fBodyAcc-mean()-X`).
* Exclude variables based on calculated magnitudes (e.g.,
`tBodyAccMag-mean()`).

This produces a set of 30 variables, corresponding to 10 types of
measurements each in the directions of the X, Y, and Z axes.

Creating the Tidy Data Set
--------------------------

The analysis script produces a "narrow" tidy set, with each row
corresponding to a given combination of subject, activity, and
measured variable. For example, there is one row containing the mean
value of all observations in the original data set for the variable
"tBodyAcc-std()-X" (standard deviation of body acceleration in the
direction of the X axis) for subject 3 while walking.

This final data set is produced by first melting the data set produced
by step 4 (i.e., containing only the mean and standard deviation
measurements), using subject and activity as id variables. This takes
a row containing 30 columns for the 30 measurements produced for a
given subject and activity and produces 30 rows in the melted data
set, one row for each measurement for that subject and activity. The
melted data thus has four columns: subject, activity, (type of)
measurement, and measured value.

This melted data set is then used to produce the final tidy data set,
by taking all rows for a given subject/activity/measurement and
computing the mean of the measured values. The final tidy data set
thus also has four columns: subject, activity, (type of) measurement,
and mean of the measured values. The total number of rows in the final
tidy data set is the product of the number of subjects times the
number of activities times the number of selected variables (30, from
above).

The final tidy data set is written to disk as a text file using
`write.table`, with one line per row and the values for each row
separated by spaces. The file can be read into R using
`read.table`. (Note that the descriptive variable names were created
without spaces so as to avoid problems when reading in the output
file.)

Format of the Tidy Data Set
---------------------------

The columns in the final tiny data set are as follows:

* Subject: An integer code identifying the subject, with values from 1
  to 30.
* Activity: A character string with the activity label, with possible
  values as follows:
    * WALKING
    * WALKING
    * WALKING_UPSTAIRS
    * WALKING_DOWNSTAIRS
    * SITTING
    * STANDING
    * LAYING
* Measurement: A character string identifying the measured variable,
  with possible values as described below.
* Mean: The mean of all values for the measured variable for the
  subject and activity in question.

The variables (in the third column) for which means were calculated
(in the fourth column) are as follows; the names are based on the
variable names in the original data set:

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

\[1\] "Human Activity Recognition Using Smartphones Dataset, Version
1.0", Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, and Luca
Oneto, Smartlab - Non Linear Complex Systems Laboratory, DITEN -
UniversitÃ degli Studi di
Genova. [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

\[2\] "Tidy Data", Hadley Wickham, RStudio. [http://vita.had.co.nz/papers/tidy-data.pdf](http://vita.had.co.nz/papers/tidy-data.pdf)
