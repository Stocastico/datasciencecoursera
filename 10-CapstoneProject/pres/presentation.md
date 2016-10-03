Data Science Specialization Text Prediction App
========================================================
author: Stefano Masneri
date: October 3rd, 2016
autosize: true
transition: concave
transition-speed: slow
font-import: http://fonts.googleapis.com/css?family=Josefin+Sans
font-family: 'Josefin Sans'

Introduction
========================================================
type: prompt
incremental: true

The objective of the Capstone project is to build a complete data product which performs text prediction. In particular, the capstone required us to do:

- [Data](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip) acquisition
- Data exploration and preprocessing
- Model creation
- App deployment


Language model
========================================================
type: prompt
incremental: true

The language model was created extracting the frequencies of words, 2-, 3- and 4-grams.
These are the steps implemented in the creation of the model:

- Use 90% of the data for training, 10% for testing
- Fix a dictionary of words after removing unigrams appearing less then *50* times
- Replace Out-of-Dictionary words in 2-, 3- and 4-grams with the special word <span style="color:red;">*&lt;UNK&gt;*</span>
- Create sparse arrays for N-grams. Each dimension contain the words in the dictionary.
- Prediction implemented as a lookup in the array (*fixing* N-1 dimensions and extracting the higher values in the remaining vector)

Accuracy
========================================================
type: prompt
incremental: true

The model has been evaluated by selecting a subset of the corpus and trying to predict every word.

- The top-3 accuracy is <span style="color:red;">*53%*</span> and the top-5 accuracy is <span style="color:red;">*64%*</span>
- Using special words for start of sentence and unknown words gives a smaller increse of accuracy (<span style="color:red;">*~3.5%*</span>)
- The model implements *stupid backoff*.
- Good-Turing backoff was tested but didn't give any improvements in accuracy 

Shiny Application
========================================================
type: section

A shiny application demonstrating the model is available [here](add.link.com).

