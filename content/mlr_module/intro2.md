---
title: Machine Learning for Biology Part 2 
date: "2021-03-30"
---

*Note: This assignment has a number of associated questions you'll find as you go through this that need to be submitted on ELMS. Some of these ask you to explain or guess why certain things may be the way that they are. I am not grading on correctness here, rather I am grading based on whether you have completed the assignment and put some thought into the answers. Feel free to discuss these with your group or with me in lab. We will likely go over some of the more important material during class as well.

# Submission

This assignment will be linked on ELMS and there should be a submission form for ASN4 (Training). You should submit this assignment individually. Feel free to work with and discuss the process and questions with teammates, other classmates, or peer mentors.

Note: This assignment has a number of associated questions you'll find as you go through this that need to be submitted on ELMS. Some of these ask you to explain or guess why certain things may be the way that they are. I am not grading on correctness here, rather I am grading based on whether you have completed the assignment and put some thought into the answers. Feel free to discuss these with your group or with me in lab. We will likely go over some of the more important material during class as well.


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
library(mlr)

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