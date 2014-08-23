gettingdatacoursera
===================

Course project for Coursera "Getting and Cleaning Data" course

Repository Files
----------------

This repository contains three files:

* `README.md`. The file you're reading.
* `run_analysis.R`. An R script to create a tidy data set from a set of
  raw accelerometer data.
* `CodeBook.md`. A code book describing the variables in the tidy data set.

Creating the Tidy Data Set from Raw Data
----------------------------------------

To create the tidy set in R or R Studio, simply put the
`run_analysis.R` script in a suitable directory and execute the
following two commands in R (or R Studio):

1. `setcd("<dir>")` (where `<dir>` is the directory containing
the `run_analysis.R` script)
2. `source("run_analysis.R")`

The `run_analysis.R` script will do the following:

1. Load any required R packages.
2. Download the original set of data files from the Internet (in
zipped form).
3. Extract the directory of data files into the working directory.
4. Read into R all of the relevant data.
5. Perform the five steps called for in the project description,
culminating in the creation of the tidy dataset:
    1. Merges the training and the test sets.
    2. Extracts only the mean and standard deviation measurements.
    3. Replace the activity numeric codes with activity names.
    4. Use descriptive variable names.
    5. Creates a second, independent tidy data set with the average of each
       variable for each activity and each subject. 
6. Write the tidy data set out as a file `tidy_data.txt`.

Selecting Variables for Analysis
--------------------------------

The original datasets contain 561 separate variables (not counting the
subject and activity codes). The course project description is
somewhat ambiguous in its discussion of which "mean" and "standard
deviation" variables to extract for further analysis.

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
