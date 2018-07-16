City of Sacramento Budget Data App
========================================================
author: Jordan Miller-Ziegler
date:  July 16, 2018
autosize: true

Overview
========================================================

- This project provides an interactive way to explore how much the City of Sacramento budgeted for various items from FY15 to FY18.

- The data are from the City of Sacramento's open data portal, data.cityofsacramento.org.

- The file itself can be downloaded here: https://opendata.arcgis.com/datasets/00aa04d56178482b8b33248d32a2cd12_0.csv

- As can be seen on the next slide, the data represent various categories of items in the Sacramento budget, and the budgeted amount.

Data
========================================================

```r
sacbudget <- read.csv("sacbudget.csv")
levels(sacbudget$FUND_SUMMARY)[1:2] <- c("CIRBS","Gas Tax")
str(sacbudget[,c(4,8,16,22,23,26)])
```

```
'data.frame':	9287 obs. of  6 variables:
 $ YEAR                      : Factor w/ 2 levels "FY15","FY16": 2 2 2 2 2 2 2 2 2 2 ...
 $ OPERATING_UNIT_DESCRIPTION: Factor w/ 13 levels "","Community Development",..: 11 11 11 11 11 11 11 11 11 11 ...
 $ FUND_SUMMARY              : Factor w/ 19 levels "CIRBS","Gas Tax",..: 6 6 6 6 6 6 6 6 6 6 ...
 $ OJBECT_CLASS              : Factor w/ 14 levels "","Charges, Fees, and Services",..: 4 4 4 12 12 12 12 12 12 12 ...
 $ ACCOUNT_CATEGORY          : Factor w/ 30 levels "","Assessment Levies",..: 8 8 18 26 26 26 22 26 27 23 ...
 $ BUDGET_AMOUNT             : int  4410 89779 -70000 5000 1500 1602 -1602 36135 2000 7020 ...
```

Data by Object Class
========================================================
For example, here are the various "object classes" and their budget amounts:

![plot of chunk unnamed-chunk-2](Reproducible Pitch-figure/unnamed-chunk-2-1.png)

App Usage
========================================================

- The user selects which category they would like to explore via one of the drop-down menus.

- For example, the user might explore the Account Category "Employee Benefits" to see how much was budgeted for employee benefit programs.

- The app will display the total spent, this amount as a percentage of the total budget, and the amount budgeted for each of the four fiscal years FY15 - FY18.

A word of caution: Being overly selective
========================================================

- The app can display any possible combination of the four input options. 

- This includes many combinations which do not occur in the budget. 

- For example, there are no account summaries of "Donations" for the "City Attorney" operating unit. 

- In this case, the app will display blank graphical output. 

- If this occurs, the user may simply broaden the search by setting one or more categories to "All".
