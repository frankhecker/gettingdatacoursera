gettingdatacoursera
===================

Course project for Coursera "Getting and Cleaning Data" course for
Frank Hecker.

Repository Files
----------------

This repository contains four files:

* `README.md`. The file you're reading.
* `run_analysis.R`. An R script to create a tidy data set from a set of
  raw accelerometer data.
* `CodeBook.md`. A code book describing the variables in the tidy data
  set and various notes about how the analysis was done.
* `tidy_data.txt`. A copy of the output file created by the analysis
  script.

Prerequisites
-------------

This script has the following prerequisites and requirements:

* You must have a reasonably current version of R and have installed
the `plyr` and `reshape2` packages.
* The script was created and tested on Mac OS X and assumes Unix-style
syntax for pathnames. You may need to change the script on other
platforms.
* You must have a working Internet connection when running the script
for the first time, in order to download the original data set.
However once the data set zip file is downloaded you can run the
script subsequently while offline.

Creating the Tidy Data Set from Raw Data
----------------------------------------

To create the tidy set, simply put the `run_analysis.R` script in a
suitable directory (which can be empty) and execute the following two
commands in R (or R Studio):

1. `setcd("<dir>")` (where `<dir>` is the directory containing
the `run_analysis.R` script)
2. `source("run_analysis.R")`

If you have already downloaded and extracted the data set yourself,
the `run_analysis.R` script should be in the same directory as the
`UCI HAR Dataset` directory. (Do _not_ put the `run_analysis.R` script
in the `UCI HAR Dataset` directory itself.)

The `run_analysis.R` script will do the following:

1. Load any required R packages.
2. Download the original set of data files from the Internet (in
zipped form) if not already present in the working directory.
3. Extract the `UCI HAR Dataset` directory of data files into the
working directory (if not already present).
4. Read in all of the relevant data files.
5. Perform the five steps called for in the project description,
culminating in the creation of the tidy dataset.
6. Write the tidy data set into the output file `tidy_data.txt`.

See `CodeBook.md` for a description of how the tidy data set output
file is created and what data it contains.
