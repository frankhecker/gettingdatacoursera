gettingdatacoursera
===================

Course project for Coursera "Getting and Cleaning Data" course

Repository Files
----------------

This repository contains three files:
* README.md. The file you're reading.
* run_analysis.R. An R script to create a tidy data set from a set of
  raw accelerometer data.
* CodeBook.md. A code book describing the variables in the tidy data set.

Creating the Tidy Data Set from Raw Data
----------------------------------------

To create the tidy set in R or R Studio, simply put the run_analysis.R
script in a suitable directory and execute the following two commands
in R (or R Studio):
1. setcd("<dir>") (where <dir> is the directory containing run_analysis.R)
2. source("run_analysis.R")

The run_analysis.R script will do the following:
1. Download the original set of data files from the Internet (in
zipped form).
2. Extract the directory of data files into the working directory.
3. Read into R all of the relevant data.  4. Perform the five steps
called for in the project description, culminating in the creation of
the tidy dataset.

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
some way on the original measurements. The analysis script is
conservative in terms of which variables to include; it reflects the
following decisions:
* Include variables that represent means and standard deviations of
raw measurements in the X, Y, and Z directions (e.g.,
"tBodyAcc-mean()-X").
* Exclude variables based on FFT calculations (e.g., "fBodyAcc-mean()-X").
* Exclude variables based on calculated magnitudes (e.g.,
"tBodyAccMag-mean()").

Creating the Tidy Data Set
--------------------------

To be written.
