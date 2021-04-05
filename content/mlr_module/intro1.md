---
title: Machine Learning for Biology Part 1 
date: "2021-03-30"
---

*Note: This assignment has a number of associated questions you'll find as you go through this that need to be submitted on ELMS. Some of these ask you to explain or guess why certain things may be the way that they are. I am not grading on correctness here, rather I am grading based on whether you have completed the assignment and put some thought into the answers. Feel free to discuss these with your group or with me in lab. We will likely go over some of the more important material during class as well.

# Submission

This assignment will be linked on ELMS and there should be a submission form for ASN4 (Training). You should submit this assignment individually. Feel free to work with and discuss the process and questions with teammates, other classmates, or peer mentors.

Note: This assignment has a number of associated questions you'll find as you go through this that need to be submitted on ELMS. Some of these ask you to explain or guess why certain things may be the way that they are. I am not grading on correctness here, rather I am grading based on whether you have completed the assignment and put some thought into the answers. Feel free to discuss these with your group or with me in lab. We will likely go over some of the more important material during class as well.

## Introduction to Data Frames

### The Basics

**Learning Objectives:**
  * Gain an introduction to the `data.frame` data structures of R
  * Access and manipulate data within these data structures
  * Import CSV data into a *pandas* `data.frame`
  * Reindex a `data.frame` to shuffle data
  
R Data Frames are a column-oriented data analysis API. They are a great tool for handling and analyzing input data, and essentially R analysis, modeling, and machine learning tools use tese data structures as inputs.
Although a comprehensive introduction to data.frames would span many pages, the core concepts are fairly straightforward, and we'll present them below. 

The primary data structures in R are the Data Frame and the vector:

  * **`data.frame`**, which you can imagine as a relational data table, with rows and columns. You can also think of this like a data-only spreadsheet, without formulas in each cell.
  * **`vectors`**, which can represent a single row or column. A `Data Frame` contains one or more `vectors` and a name for each `vector`.

The data frame is a commonly used abstraction for data manipulation. Similar implementations exist in [Spark](https://spark.apache.org/) and [Python](https://pandas.pydata.org/).

One way to create a `vector` is to direct construct it with the `c()` function. For example, this line creates a vector directly:

```r
c('San Francisco', 'San Jose', 'Sacramento')
```

`data.frame` objects can be created by passing several name-vector pairs mapping the column names to their respective vectors:

```r
data.frame(city_name=c('San Francisco', 'San Jose', 'Sacramento'), 
           population=c(852469, 1015785, 485199))
```

But most of the time, you load an entire file into a `data.frame`. `data.frame`s can be created directly from CSV files like we have looked at before. Run the following to load the data from our earlier modules and look at the first few rows:

```r
covid19_genome_dataframe <- read.csv("http://training.fire.tryps.in/covid19_jan2021.csv", sep=",", comment='#')
covid19_genome_dataframe
```

(You can also click on the corresponding variable in the top-right "Environment" pane of RStudio Server to get a prettier view.)

There are many useful tools and packages available for R. One useful function we can use is `summary()` which lets us create a nice summary view of a `data.frame`:

```r
summary(covid19_genome_dataframe)
```

R also includes powerful tools to quickly create plots from `data.frame`s:

```r
hist(covid19_genome_dataframe$Length)
```

(We may also use the very, very nice plotting library `ggplot2` in the future.)

### Accessing Data

You can access data using "indexing" features:

Select columns by name with the `$` selector.

```r
cities = data.frame(city_name=c('San Francisco', 'San Jose', 'Sacramento'), 
                    population=c(852469, 1015785, 485199))
cities$city_name
```

Index by row, column range with `[]` brackets:

```r
cities[1:2,]
```

In addition, *R* provides an extremely rich API for advanced [indexing and selection](https://stats.idre.ucla.edu/r/modules/subsetting-data/) that is too extensive to be covered here. Additionally, extensions to data frames like [`data.table`](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html) extend these data structures with powerful and modern abilities.

### Manipulating Data

You can apply basic arithmetic operations in parallel to vectors. For example:

```r
cities$population / 1000
```

```r
log(cities$population, base=10)
```

For more complex single-column transformations, you can use `sapply()`. `sapply` accepts as an argument a **function**, which is applied to each value in a vector

The example below creates a new vector that indicates whether `population` is over one million:

```r
lapply(cities$population, FUN=(function(val) val>1000000) )
```

Modifying `data.frames` is also straightforward. For example, the following code adds two new columns to an existing `data.frame`:

```r
cities$area <- c(46.87, 176.53, 97.92)
cities$population_density <- cities$population / cities$area
cities
```

#### Question #1

Modify the `cities` data frame by adding a new boolean column that is True if and only if *both* of the following are True:

  * The city is named after a saint.
  * The city has an area greater than 50 square miles.

**Note:** Boolean `vectors` are combined using the bitwise/elementwise `&` operator, rather than the traditional `&&` operator.

**Hint:** "San" in Spanish means "saint."


### Indexes and row labels

Both `vectors` and `data.frame` objects may also define an *names* that assign an identifier value to each vector item or `data.frame` row or column. 

By default, at construction, R assigns index values that reflect the ordering of the source data. Once created, the index values are not stable; that is, they do change when data is reordered.

```r
row.names(cities)
```

```r
cities[c(2,0,1)]
```

Reindexing is a great way to shuffle (randomize) a `data.frame`. In the example below, we take the index, which is a vector, and pass it to R's `sample` function, which can shuffle its values in place.  Selecting rows by those indices with this shuffled vector causes the `data.frame` rows to be shuffled in the same way.

Try running the following multiple times!

```r
cities[sample(row.names(cities)),]
```

#### Question #2

This "reindexing" method allows index values that are not in the original `data.frames`'s index values. Try it and see what happens if you use such values! Why do you think this is allowed?

### Looking at our CCLE data

Let's take a look at some of the CCLE data we will use in this module. We will access the data from our training site and read it in similar to before. Here, we will add an argument `row.names=1` to specify to *R* that the first column in the CSV should be used to name each row in the data frame.

```r
metadata_url <- 'https://raw.githubusercontent.com/jgoodson/fire-cb-2021-training/hugo-dev/static/processed_metadata_targets.csv'
ccle_metadata <- read.csv(metadata_url, sep=',', row.names=1)
```

This `data.frame` now contains both our CCLE metadata in the first three rows, indicated the tissue type, cancer type, and gender of each of the 1037 CCLE samples. The remaining columns have numbers indicating the susceptiblity to each of 24 different cancer drug compounds. We can use `summary()` to look at some statistics for these columns:

```r
summary(ccle_metadata)
```

Here, we see that not all CCLE cell lines were tested! Indeed, only about 492 of these have non-NaN (Not a Number) data in our table here, and some drugs are available for even fewer. 

We can also see that the maximum value across the board is no more than "8". What is happening here?

The way that susceptibility is measured in this case is a biochemistry concept called IC50 or EC50. This is a measurement of the concentration of a compound required to reach 50% of the maximum inhibition possible. If complete killing of cancer cells occurs, we would say that is 100% inhibited, whereas if a drug doesn't slow them down at all, they are 0% inhibited. The amount of a drug necessary to get to 50% would be called the IC50 or EC50 and can represent how powerful that drug is: the lower, the better.

We measure this by exposing the cells to a variety of concentrations of the drug compounds and measuring the inhibition for each. In this case, the maximum concentration used in the experiment was "8 uM" or 8-micromolar. Concentrations above that aren't relevant because they are nearly impossible to reach and would probably kill patients. If a value is 8, we can safely assume that the cells are not vulnerable to that drug.

![Inhibition Curve][curvefit]

[curvefit]: /images/curvefit.png "Nested Folders"

We might want to eliminate rows that don't have useful data. *R* has a variety of functions to test various aspects of the data. We can use the `is.na()` function to test whether these are valid numbers or not.

```r
is.na(ccle_metadata$PHA-665752)
```

We can then use R selection to choose only those rows of the dataframe that aren't NA for PHA-665752:

```r
ccle_metadata[!is.na(ccle_metadata$PHA-665752),]
```

(The `!` here is a *unary* "not" operator that inverts the TRUE/FALSE vector)


#### Question #3

How many different types of "histology" samples are present in our dataset? You should be able to use the `unique()` function on the "histology" column. Please include your code statement as part of your question answer. 


## Introduction to Machine Learning

R is an extremely frequently used language in analytics and data science. R is basically built on statistical, modeling or machine learning algorithms. Although the base R language includes a wide array of useful tools, the bigger [R ecosystem](https://cran.r-project.org/) includes an astounding array of amazing analytics tools. There are two primary ecosystems for doing modeling and machine learning in R: [`caret`](https://topepo.github.io/caret/) and [`mlr`](https://mlr.mlr-org.com/). Although both are excellent, we will be using `mlr` in this module, largely because of its closer similarity to the Python equivalent: [scikit-learn](https://scikit-learn.org/stable/).

### Features and Targets

In general, machine learning operates on one or more *features*. You can think of these as the *independent variables* that a model will use to make its predictions. These *features* are the *input* to our models.

When doing machine learning, we would, obviously, like our machines to *learn* something. For most applications, this means that we would like our machiens to take some input and predict some sort of *output*. We use machine learning algorithms to *fit* a model to make it learn to *target* particular output values given input features. The *target* we use in a machine learning algorithm could also be thought of as the *dependent variable*.

#### Targets

In `mlr`, targets are generally one-dimensional vectors that are stored as a column in your data frame. Target arrays can either be numerical, generally continuous decimal or floating point values, or they can be categorical, with textual labels describing different classes of data, usually stored as a variant of vector: `factor`s.

We will start a bit backwards, with our targets. We would like to be able to predict drug sensitivity of our CCLE cell lines (our target) given their transcriptome profiles as input (our features). We already have our target array in the form of the columns of our `ccle_metadata` data frame. Here is how we would extract a vector containing the valid values for Topetecan (a topoisomerase inhibitor often used for ovarian, cervical, and lung carcinoma treatment).

```r
ccle_metadata$Topotecan[!is.na(ccle_metadata$Topotecan),]
```

#### Features

Features are generally organized into two-dimensional matrices/arrays or data frames. In `mlr`, this feature matrix or table is usually combined with the target and referred to as `data`. In arrays or matrices, this is of shape \[num_samples, num_features\], where the first dimension (rows) represents each independent data point, and the second dimension (columns) represents the different features.

We haven't yet looked at what our features will be for our CCLE transcriptomes, time to change that! I've processed and prepared these transcriptomes for you. This is quite a big file (almost 200 MB unpacked) so it may take a few seconds to load. We will switch to the `read_table()` function from the `readr` library since this file is compressed with gzip compression:

```r
library(readr)
ccle_txomes <- read.csv('/shared/data/processed_transcriptome.csv', sep=',', row.names=1)
ccle_txomes[1:10, 1:10]
```

The rows of this table match up with the 1037 CCLE cell lines from our metadata table. The first column should match our row names. For various reason, `data.table`s do not allow row names. The columns are each a human gene. 

The values in this table represent the *log-transformed* estimate of transcript abundance for each gene. If we counted up the number of transcripts measured by an RNA-seq experiment it might range from a few thousand to hundreds of millions. For various reasons, we frequently "log-transform" this type of data, compressing these values down to a much smaller range from ~3-12.


#### Question #4

What is the highest expression measurement in the dataset? Which sample and gene does this correspond to? 

*You will definitely want to use the R `apply()` function. It is similar to lapply but works on a dataframe and has an additional argument. Call `apply(df, 1, FUN)` for rows and `apply(df, 2, FUN)` for columns. Do not simply call max(df) or you will run out of memory and crash your instance and need to restart from the beginning.* 

### Using individual features

Our DataFrame has over 18000 different potential features, which is quite a bit more than are reasonably usable by most machine learning algorithms, and definitely more than we can easily visualize. We will likely want to either select a smaller number of genes or create some "synthetic" features that combine one or more of our transcript estimates into a single "feature" for ML purposes. 

For now, we will experiment with just one gene at a time. Let's look at the BRCA1 gene, coding for the "Breast cancer type 1 susceptibility protein" and treatment with Topotecan. Here, we are going to switch to ggplot2 because it just works so much better with data frames:

```r
library(ggplot2)

data <- data.frame(BRCA1=ccle_txomes$BRCA1, Topotecan=ccle_metadata$Topotecan)

ggplot(data, aes(x=BRCA1, y=Topotecan)) + geom_point() + geom_smooth(method="lm")
```

We construct a plot with `ggplot()`, give it the data, and specify what columns are for x and y. We can then (literally) add all sorts of functionality by combining this with other ggplot functions, in this case, creating scatter points with `geom_point()` and a linear trendline with `geom_smooth(method="lm")`.

There seems to be a bit of a negative correlation here, although recall that lower values for our y-axis (IC50 of the compound) mean "more susceptible". This indicates that higher BRCA1 expression might indicate more susceptibility to Topotecan treatment!

Let's look at a different gene, perhaps unlikely to be too involved in many cancers, the HTT gene in which certain mutations are responsible for Huntington's Disease:

```r
data <- data.frame(HTT=ccle_txomes$HTT, Topotecan=ccle_metadata$Topotecan)

ggplot(data, aes(x=HTT, y=Topotecan)) + geom_point() + geom_smooth(method="lm")
```

This appears to also have a bit of a negative correlation, though not as extreme. We probably can't just use a single feature/gene to predict drug susceptiblity.

We also have another issue, we can see that our y-axis values (IC50 susceptibility values) are not very evenly or normally-distributed, most of them are quite small, although others are up at 8 uM. It turns out that the experiment used expoentially-decreasing amounts of drugs, from 8 to 2 to to 0.5, etc. If we want to "undo" that effect, we can do something similar to our log-scale transcription data and "log-transform" our IC50 values!

```r
data$Topotecan <- log10(data$Topotecan)

ggplot(data, aes(x=HTT, y=Topotecan)) + geom_point() + geom_smooth(method="lm")
```

Ah, that is better, now our Topotecan IC50 values are spread out over a larger range, closer to normally-distributed. This process, a type of *normalization*, will help our models understand the data better. We can do this to all of our data at once, if we like:

```r
ccle_targets_log <- log10(ccle_metadata[-c(1:3)])
ccle_targets_log
```

Here we use *negative selection* to exclude the first three, non-numeric variables.

We can transform or [*preprocess* our input data](https://mlr.mlr-org.com/articles/tutorial/preproc.html) in a variety of ways. So far we have only looked at one (log transformation), but many are available and might be suitable for different problems.

#### Question #5

Try to make a similar plot to the above but for [Paclitaxel](https://en.wikipedia.org/wiki/Paclitaxel) and [a-Tubulin](https://en.wikipedia.org/wiki/Tubulin) (TUBA1A). What kind of relationship does TUB1A expression have with Paclitaxel sensitivity?

## This training continues

This first half of our Machine Learning for Biology training module asked you to begin understanding our CCLE data and how to maniuplate it in R. In the [second half](/mlr_module/intro2/), we will use the `mlr` R modeling and machine learning libraries to create models to try to understand and predict how cancer cell lines respond to chemotherapies.
