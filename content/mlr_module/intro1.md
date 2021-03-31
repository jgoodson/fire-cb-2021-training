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

#todo insert image

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

## Let's teach some machines

You might be asking, *when are we going to do machine learning?* Arguably, we already are! Machine learning is, at its core, fitting a model to some input features to predict an output target. By telling ggplot2 to make a "lm" plot, it fit a simple, linear, model on one variable (the X value, one gene expression estimate) to predict another (the y value, the IC50 values). This process, predicting a continue value, is called *regression*, both in the context of machine learning and in statistics. In fact, linear models and linear regression are a great starting point for modelling in both statistics and machine learning. Regression is one of two, related, core forms of machine learning: regression and classification.

### Regression

*Regression* is a form of modeling where you are trying to predict a continuous, numerical value from one or more features. Perhaps the simplest method, linear regression, is commonly used in many, many fields. You may have already been exposed to linear regression in classes like chemistry, physics, or statistics. We can do linear regression with a single feature or independent variable, like in the previous section, or we can do it with more than one! Linear regression models take the form of (all equivalent):

$y = ax+b$ 

or 

$y=wX + w_0$

or

$y=w_1x_1 + w_2x_2 + ... + w_0$

The idea is that we input our feature values as X, these are multiplied by some *learned* weight `w`, added together with a *intercept* or *bias*, and the resulting value is the prediction for our target variable! These "weights" are the values that our machine is *learning* during the process of fitting a model to data.

Linear regression can be solved exactly by a particular mathematical process caled "ordinary least squares", but other types of regression need more complicated algorithms to learn their weights. A simple linear regression with one feature variable only has two weights, while complicated neural network models might have billions. At their core, they are both models and the process of fitting them is very similar!

Let's use mlr to do a simple linear regression with two feature varaibles:

```r
data <- cbind(ccle_txomes[c('BRCA1', 'HTT')], ccle_targets_log[c('Topotecan')])
topo_valid_cell_lines = !is.na(ccle_targets_log['Topotecan'])
topo_valid_data <- data[topo_valid_cell_lines,]

regr.task = makeRegrTask(id="topo2", data=topo_valid_data, target="Topotecan")
regr.lrn = makeLearner("regr.lm")
model = train(regr.lrn, regr.task)
```

Since we had two features, we should have two weight values, one for each value, and one intercept value. We can find those by access some specific attributes of our `WrappedModel` object:

```r
model$learner.model
```

*Don't worry about understanding all the code in this next block yourself*. The following code makes a 3D scatterplot and surface plot. An linear equation in three dimensions makes a surface instead of a line ($z = f(x,y)$). You should see an interactable 3d plot when you run this, click around on it to manipulate it.

We can see that the linear model creates a surface going through the middle of a cloud of data points. We can't easily expand our visualizations past three dimensions, but machine learning algorithms can easily work in dozens or hundreds of dimensions at once. 

```r

fig <- plot_ly(
  data=topo_valid_data,
  x=~BRCA1,
  y=~HTT,
  z=~Topotecan,
  type="scatter3d",
  mode="markers",
  marker=list(size=2)
  )

i = model$learner.model$coefficients[1]
w1 = model$learner.model$coefficients[2]
w2 = model$learner.model$coefficients[3]

x=seq(from=min(topo_valid_data$BRCA1), to=max(topo_valid_data$BRCA1), length.out=10)
y=seq(from=min(topo_valid_data$HTT), to=max(topo_valid_data$HTT), length.out=10)
z=outer(x,y,(function(a, b) i + a*w1 + b*w2))

fig <- fig %>% add_surface(x=x, y=y, z=z)
fig
```

#### Question #6

Why can't we easily use normal 2d scatter plots to plot this last model? Can you think of any ways we could specifically show the relationship between only one of these genes and Topotecan sensitivity? (No right/wrong here, just ideas)

#### Metrics

The surface defined by our linear model does a pretty mediocre job of matching all of our data points. We might want to quantitatively measure how well our models do at predicting our data. This is usually done by calculating one or more [*metrics* to measure peformance](https://mlr.mlr-org.com/articles/tutorial/performance.html).

Metrics commonly used for evaluating regression models include:

- Mean Absolute Error (MAE): The absolute value of the difference between each data point and the prediction the model makes for it, averaged across all data points.
- Mean Squared Error (MSE): The same idea as the MAE, but each difference is squared and then averaged together. This penalizes "wronger" answers more.
- Explained variance: A function that gives, roughly-speaking, a measurement of how much variability in the data is explained by the model. A perfect model gets a value of 1.0, a model just guessing the mean value gets a 0.0, and an actively-bad model might get a negative value.
- Correlation Coefficients: Measurements of the correlation between the true and predicted target values. 

mlr comes pre-programmed with a wide variety of metrics. We can use these to compare models and help us determine which models or features are most effective.

```r
pred = predict(model, task=regr.task)
print(performance(pred, measures=mse))
print(performance(pred, measures=mae))
print(performance(pred, measures=expvar))
```

#### Question #7

Which of the four metrics shown here do you think would be more suitable for comparing models trained on slightly different datasets? Why?

### Classification

Not everything we want to create a model for can be quantified as nice rational numbers. Very frequently we work with *categories*, where some item fits into one category or another. In this case, we might draw a threshold and say that any cell lines below a certain IC50 value are susceptible, while those above that value are not. Exactly how we might pick a threshold really depends on the context and all sorts of domain-specific knowledge, but let's take a look at a *heatmap* of the IC50 values to make that choice somewhat arbitrarily. Sorry, this code is a bit complex to make it pretty.

```r
ccle_targets_log$cell_line = rownames(ccle_targets_log)

ccle_targets_log[!is.na(ccle_targets_log$Irinotecan),] %>%
gather(key=compound, value=ic50, colnames(ccle_targets_log)[-length(ccle_targets_log)]) %>%
  ggplot(aes(compound, cell_line, fill=ic50)) + 
    geom_tile() + 
    scale_fill_viridis(direction=-1) +
    theme(axis.text.x = element_text(angle = 45, vjust=1, hjust=1)) +
    theme(axis.text.y = element_blank())

```

We can see that across all drugs, sensitivites vary substantially across our range, but some drugs seem to kill all cancer cell lines at low concentrations while others only have very few effects. Unfortunately, one threshold for everything may just not work, some drugs may just need higher doses than others! This is where field-specific knowledge or additional research might be required to actually make an informed decision. It isn't always possible to make these sorts of choices *a priori* from the machine learning perspective.

Let's take a look at PD-0325901, a drug specifically for neurofibromas:

```r
hist(ccle_targets_log[,"PD.0325901"])
```

Although there is no obvious cutoff, let's pick a threshold of -1.0, or 0.1 uM/100 nM for now.

```r
pd_valid_cell_lines = !is.na(ccle_targets_log[,'PD.0325901'])
PD_0325901_sensitive = ccle_targets_log[pd_valid_cell_lines,]['PD.0325901'] < -1.0
```

Now, we can visualize a relationship between our PD-0325901 treatment and two genes targetted by this drug with a simple scatterplot and colors for the sensitivity:

```r
data <- cbind(ccle_txomes[pd_valid_cell_lines, c('MAP2K1', 'MAP2K2')], data.frame(PD_0325901_sensitive))
ggplot(data, aes(x=MAP2K1, y=MAP2K2, color=PD.0325901)) + geom_point()
```

Even though MAP2K1 and MAP2K2 are the direct targets of this drug, they don't seem to do a good enough job to explain which cell lines would be sensitive to it. Let's start creating some classification models and metrics so we can decide how well individual sets of genes work to predict the sensitivity to PD-0325901. We will use one of the most-simple classifier models, *logistic regression*. Despite the name, logistic regression is for classification, not regression. I know, don't blame me. This is similar to before, but now we use our new data, a new target column, and a `classif.multinom` learner:

```r
classif.task = makeClassifTask(id="pd2", data=data, target="PD.0325901", positive="TRUE")
classif.lrn = makeLearner("classif.multinom")
model = train(classif.lrn, classif.task)
```

#### Metrics

Like regression, there are many ways of measuring how good a classifier is. You are probably more familiar with some of these, like *accuracy*, the fraction of the answers that the classifier gets correct. We should discuss two related concepts now. 

When we talk about binary classification (classification into two groups), we have two values, the actual target value, and the predicted value. A **positive** value is when the classifier predicts a positive value, and **negative** is when the classifier predicts a negative, *regardless of whether it is correct*. We consider a classifcation **true** when the actual value matches the predicted value, either positive or negative. If the classifier is wrong, we consider that **false**. By combining these two, we can categorize every prediction a classifer makes:

- True Positive (TP): A correct guess for the *positive* category (Good)
- False Positive (FP): An incorrect guess, guessing that the value is *positive* (Bad)
- True Negative (TN): A correct guess that the value is *negative* (Good)
- False Negative (FN): An incorrect guess that the value is negative (Bad)

The relative importance of positives and negatives depends on the context. If we were doing a COVID test, false positives are probably less important that false negatives!

Since we care about all four of these, to varying degrees depending on our application, we usually calculate the *rates*, or relative amounts of all four, resulting in something called the [*confusion matrix*](https://en.wikipedia.org/wiki/Sensitivity_and_specificity#Confusion_matrix). We also frequently use various combinations of these four rates to calculate a variety of metrics, including:

- Accuracy - How many guesses are correct?
  - $(TP+TN)/(TP+TN+FP+FN)$
- Sensitivity/Recall or "true positive rate" - What proportion of positive values are correct?
  - $TP/(TP+FN)$
- Specificity or "true negative rate" - What proportion of negative values are correct?
  - $TN/(TN+FP)$
- Precision or "positive predictive value" - What proportion of *positive guesses* are correct?
  - $TP/(TP+FP)$

Let's take a look at how some of these metrics interact:

```r
pred = predict(model, classif.task)
performance(pred, measures=acc)
```

Look at that! Our model is 84% accurate, that sounds great...at first. Consider what percentage of our data points are negative:

```r
sum(pred$data$truth == FALSE) / length(pred$data$truth)
```

Oh, maybe 84% accuracy isn't so good when you can just always guess "False" and get 84% accuracy. What if we look at precision and recall? In mlr, we can get all of the relavent binary classification measures in one go with `calculateROCMeasures()`:

```r
calculateROCMeasures(pred)
```

#### Question #8

The previous command should give you an explanation of each metric. What are our precision and recall? What do you think these message means for our metric? Do you think this invalidates our conclusions?

### Feature Selection

Let's give our classifier a bit more data to work with: let's select one hundred random genes from the beginning of the list, alphabetically.

```r
data <- cbind(ccle_txomes[pd_valid_cell_lines, 1:100], data.frame(PD_0325901_sensitive))
classif.task = makeClassifTask(id="pd100", data=data, target="PD.0325901", positive="TRUE")
classif.lrn = makeLearner("classif.multinom", predict.type="prob")
model = train(classif.lrn, classif.task)

pred = predict(model, classif.task)
calculateROCMeasures(pred)
```

Better! We are up to 93% accuracy with a respectable 84% precision and 66% recall. We can make some plots to better illustrate how our classifier performs now. The plots measure metrics using every possible "threshold" that the classifier could use to decide positive/negative and show them as a line plot.

 First, we will plot a so-called "Receiver Operating Curve" or ROC, which plots the true positive rate against the false positive rate. The ideal classifer is a line as close to the top-left as possible (all true positives, no false positives). A classifier that always guesses one value will be a straight line along the y=x line.

People will also frequently measure the area under this curve, the ROC-AUC (area under curve), as a classifier metric.

```r
df = generateThreshVsPerfData(pred, measures = list(fpr, tpr, mmce))
plotROCCurves(df)
performance(pred, auc)
```

Another frequently-used plot is the precision-recall curve. This curve is compared to a line at the fraction of the population that is the positive class, in this case about 16%. The better the classifier, the higher this line will be across the board.

```r
df = generateThreshVsPerfData(pred, measures = list(ppv, tpr))
plotROCCurves(df, diagonal=FALSE)
```

A great resource for how these curves work and when to use them can be found here: https://mlr.mlr-org.com/articles/tutorial/roc_analysis.html

#### Overfitting

We have a lot of data, why not use it? Let's make our logistic regression classifier even better by using five hundred genes:

```r
data <- cbind(ccle_txomes[pd_valid_cell_lines, 1:500], data.frame(PD_0325901_sensitive))
classif.task = makeClassifTask(id="pd500", data=data, target="PD.0325901", positive="TRUE")
classif.lrn = makeLearner("classif.multinom", predict.type="prob")

model = train(classif.lrn, classif.task)
pred500 = predict(model, classif.task)

calculateROCMeasures(pred500)
```

It is perfect! We can perfectly predict susceptibility with no error at all, problem solved. 

Or not... predicting something as complicated as drug sensitivity in cancer cell lines is not that easy or simple, so what is happening? We are *overfitting* our problem. We are only predicting about 500 different values, but we have that many features! The model should have five hundred unique combinations of features and *can basically memorize the input and regurgitate it back to use*.

How do we deal with this problem? There are two things we can do:

1. Ensure we are using a small number of features relative to our number of observations/samples.
2. Train our model on a subset of the data and test how effective the model is at *generalizing* to data it has not seen.

These each have their place. All things equal, a simpler model with less features that can do equally good at prediction is better. *Don't use a neural network when logistic regression will suffice.* The question of "how much is too much" is complicated, but by splitting our data into *training* and *testing* data we can quantitatively measure how good our models are at generalizing. mlr has [excellent tools](https://mlr.mlr-org.com/articles/tutorial/resample.html) to help us do this:

```r
rdesc = makeResampleDesc("Holdout", split=2/3)
res500 = resample(classif.lrn, classif.task, rdesc, measures=list(acc, ppv, tpr))
res500
```

This re-trains our model on 2/3 of our data, uses the other 1/3 to test performance, and reports back accuracy, precision (ppv) and recall (tpr). After splitting our data randomly into training and testing "splits", training our model on one, and evaluating its performance on the other, we get a much more reasonable 68% accuracy (remember 84% of the samples are negative in this case), with mediocre precision and recall. There is lots of room for improvement!

```
df500 = generateThreshVsPerfData(res500$pred, measures = list(fpr, tpr, mmce))
plotROCCurves(df500)
```

#### Question #9

Take a look at this page on [Cross-Validation](https://machinelearningmastery.com/k-fold-cross-validation/). What is cross-validation and how does it compare with what we did in this last step?

#### Finding the best genes to use as features

We know that some genes are going to be irrelevant, some are important, but that we will need a combination to get good performance, but cannot use too many without overfitting. How can we go about picking out which combination may be useful? The [`feature_selection` component](https://mlr.mlr-org.com/articles/tutorial/feature_selection.html) of mlr features a variety of approaches to do this.

One general method is to calculate various statistics on the basic dataset to try to determine the relative "importance" of each feature, then choose the most important features. We can use `generateFilterValuesData()` to do this. First, we set up a task with all our genes genes (definitely overfitting). We then use the `generateFilterValuesData` function to generate importances for all of our genes. Here, we will use an ANOVA or analysis-of-variance test to rank our genes.

```r
data <- cbind(ccle_txomes[pd_valid_cell_lines, ], data.frame(PD_0325901_sensitive))
classif.task = makeClassifTask(id="pd_full", data=data, target="PD.0325901", positive="TRUE")
fv = generateFilterValuesData(classif.task, method = "anova.test")
fv
```

We can also choose just a subset, in this case, the top twenty, and create a new, smaller task to fit and evaluate:

```r
filtered.task = filterFeatures(classif.task, method = "anova.test", abs = 20)

rdesc = makeResampleDesc("Holdout", split=2/3)
res20best = resample(classif.lrn, filtered.task, rdesc, measures=list(acc, ppv, tpr))
print(calculateROCMeasures(res20best$pred))
df20best = generateThreshVsPerfData(res20best$pred, measures = list(fpr, tpr, mmce))
plotROCCurves(df20best)
```

Very nice! With only twenty genes and training on our training data, we get 87% accuracy and 65/50% precision/recall on our test set. This is substantially better than our first choice of 500 random genes on the same problem. More data is good, but a ton of crappy data is no substitute for good data.

### Creating composite features

Although using individual genes directly as our individual features is effective, there are other ways we can create a smaller number of features to use in our models. One class of methods, based on a variety of linear algebra techniques, are known as "dimensionality reduction". We saw before that adding a second feature to our models makes it a "three dimensional" problem. We have over 18,000 features so by using them all our problem has tens of thousands of dimensions! That is definitely too unweidly for most algorithms. 

While we can simply take the most-useful dimensions, and alternative is to *create* new dimensions formed from combinations of our existing features. There are many ways to do this, both supervised and unsupervised. We'll start with perhaps the simplest and most commonly-used method: [Principal Component Analysis (PCA)](https://www.datacamp.com/community/tutorials/pca-analysis-r).

I'm not going to go over how PCA works here, but the short version is that it projects our data into new dimensions, packing as much information into as few dimensions or "composite feature" as possible. 

```r
pca = prcomp(ccle_txomes, rank=20)
pca$x[pd_valid_cell_lines, ]
```

Now instead of a 493 x 18874 matrix of features, we have only a 493 x 20. We can use this to fit our model instead:

```r
data <- cbind(pca$x[pd_valid_cell_lines, ], data.frame(PD_0325901_sensitive))
classif.task = makeClassifTask(id="pd20pca", data=data, target="PD.0325901", positive="TRUE")
classif.lrn = makeLearner("classif.multinom", predict.type="prob")

res20pca = resample(classif.lrn, filtered.task, rdesc, measures=list(acc, ppv, tpr))

calculateROCMeasures(res20pca$pred)
```

This is (in some ways, but not others) an improvement over our 500 random features, but not as good as 20 carefully-selected features. Perhaps a combination of methods or different methods might result in even better models!

We can get a quick overview of all of our attempts to compare them directly:

```r
df_compare = generateThreshVsPerfData(list(pred500=res500, pred20best=res20best, pred20pca=res20pca), measures = list(fpr, tpr, mmce))
plotROCCurves(df_compare)
```

#### Question #10

PCA is perhaps more-frequently used for visualzation purposes. Using the ggplot2 [PCA example](https://cran.r-project.org/web/packages/ggfortify/vignettes/plot_pca.html), how can you visualize the two primary principal components (most important composite features) from our PCA?


## Next Steps

Our goal in this module is to use the transcriptome data to create the best model we can at predicting the drug response of unseen samples. Concepts we may want to take advantage of for our deliverable include:

- [Alternative models for supervised classification learning]()
- [Cross-Validation to automate train/test splitting]()
- [Hyperparamter tuning for models that use them]()
- [Feature selection]() and [engineering]()