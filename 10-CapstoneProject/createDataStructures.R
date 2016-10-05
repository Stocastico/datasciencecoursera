# required libraries
library(slam)
library(Matrix)
library(dplyr)
library(tidyr)
library(data.table)

#### UNIGRAM ####
#LOAD DATA FROM DISK
load('/storage/laur/Personal/MasneriStefano/data/freq_1.rda')

# reduce number of elements, keep all elements with at least 70 counts
THRESH_UNIGRAM = 80 
freq_unigram_all_thresh = freq_unigram_all[freq_unigram_all$frequency >= THRESH_UNIGRAM, ]

unknown = list('<UNK>', THRESH_UNIGRAM)
freq_unigram_all_thresh <- rbind(freq_unigram_all_thresh, unknown)
NUM_WORDS <- dim(freq_unigram_all_thresh)[1]
keep <- c(3, 5:NUM_WORDS)
freq_unigram_all_thresh <- freq_unigram_all_thresh[keep, ]
NUM_WORDS <- dim(freq_unigram_all_thresh)[1]

# set frequency as integers, then sort unigrams, and rename rows to go in order
freq_unigram_all_thresh$frequency <- as.integer(freq_unigram_all_thresh$frequency)
freq_unigram_all_thresh_sorted <- freq_unigram_all_thresh[with(freq_unigram_all_thresh, order(-frequency, rn)), ]
row.names(freq_unigram_all_thresh_sorted) <- 1:NUM_WORDS

# will be used later
myDict <- freq_unigram_all_thresh_sorted$rn # list of available words
idxUnknown <- match('<UNK>', myDict)

rm(keep, freq_unigram_all, freq_unigram_all_thresh)

#### BIGRAM ####
#LOAD DATA FROM DISK
load('/storage/laur/Personal/MasneriStefano/data/freq_2.rda')

# now for the bigram. first, reduce the number of elements (at least 3 counts)
THRESH_BIGRAM = 4
freq_bigram_all_thresh = freq_bigram_all[freq_bigram_all$frequency >= THRESH_BIGRAM, ]

# split the words in bigram
freq_bigram_separate <- separate(freq_bigram_all_thresh, rn, c("w1", "w2"), sep = " ")

# now we want to convert the words into indexes
freq_bigram_separate$w1_idx  <- match(freq_bigram_separate$w1, myDict)
freq_bigram_separate$w2_idx  <- match(freq_bigram_separate$w2, myDict)

# it may happen that we have a not exact match, so take care of it.
freq_bigram_separate$w1_inDict <- freq_bigram_separate$w1 %in% myDict
freq_bigram_separate$w2_inDict <- freq_bigram_separate$w2 %in% myDict

# remove the lines where the second word in not in dictionary
freq_bigram_separate <- freq_bigram_separate[freq_bigram_separate$w2_inDict]

# Then, replace words not in the dictionary with the index of unknown word
freq_bigram_separate$w1_idx[!freq_bigram_separate$w1_inDict] <- idxUnknown
freq_bigram_separate$w2_idx[!freq_bigram_separate$w2_inDict] <- idxUnknown

# replace also NAs with the index for unknown word
freq_bigram_separate$w1_idx[is.na(freq_bigram_separate$w1_idx)] <- idxUnknown
freq_bigram_separate$w2_idx[is.na(freq_bigram_separate$w2_idx)] <- idxUnknown

# remove columns we don't need anymore
freq_bigram_separate$w1 <- NULL
freq_bigram_separate$w2 <- NULL
freq_bigram_separate$w1_inDict <- NULL
freq_bigram_separate$w2_inDict <- NULL

# now, adding the unknonw word we have duplicate indexes values. Sum over them before proceeding 
freq_bigram_separate_aggr <- aggregate(freq_bigram_separate$frequency, by = list(freq_bigram_separate$w1_idx, freq_bigram_separate$w2_idx),FUN = sum)
colnames(freq_bigram_separate_aggr) <- c("w1_idx", "w2_idx", "frequency")

# then create a sparse matrix to store bigrams frequencies
indexes <- as.matrix(freq_bigram_separate_aggr[, 1:2])
bigram_sparse <- simple_sparse_array(i = indexes, v = freq_bigram_separate_aggr$frequency, dim=c(NUM_WORDS, NUM_WORDS))

rm(indexes, freq_bigram_all, freq_bigram_separate, freq_bigram_all_thresh, freq_bigram_separate_aggr)

#### TRIGRAM ####
#LOAD DATA FROM DISK
load('/storage/laur/Personal/MasneriStefano/data/freq_3.rda')

# now for the trigram. first, reduce the number of elements (at least 3 counts)
THRESH_TRIGRAM = 3
freq_trigram_all_thresh = freq_trigram_all[freq_trigram_all$frequency >= THRESH_TRIGRAM, ]

# split the words in trigram
freq_trigram_separate <- separate(freq_trigram_all_thresh, rn, c("w1", "w2", "w3"), sep = " ")

# now we want to convert the words into indexes
freq_trigram_separate$w1_idx  <- match(freq_trigram_separate$w1, myDict)
freq_trigram_separate$w2_idx  <- match(freq_trigram_separate$w2, myDict)
freq_trigram_separate$w3_idx  <- match(freq_trigram_separate$w3, myDict)

# it may happen that we have a not exact match, so take care of it.
freq_trigram_separate$w1_inDict <- freq_trigram_separate$w1 %in% myDict
freq_trigram_separate$w2_inDict <- freq_trigram_separate$w2 %in% myDict
freq_trigram_separate$w3_inDict <- freq_trigram_separate$w3 %in% myDict

# remove the lines where the last word is not in dictionary
freq_trigram_separate <- freq_trigram_separate[freq_trigram_separate$w3_inDict]

# Then, replace words not in the dictionary with the index of unknown word
freq_trigram_separate$w1_idx[!freq_trigram_separate$w1_inDict] <- idxUnknown
freq_trigram_separate$w2_idx[!freq_trigram_separate$w2_inDict] <- idxUnknown
freq_trigram_separate$w3_idx[!freq_trigram_separate$w3_inDict] <- idxUnknown

# replace also NAs with the index for unknown word
freq_trigram_separate$w1_idx[is.na(freq_trigram_separate$w1_idx)] <- idxUnknown
freq_trigram_separate$w2_idx[is.na(freq_trigram_separate$w2_idx)] <- idxUnknown
freq_trigram_separate$w3_idx[is.na(freq_trigram_separate$w3_idx)] <- idxUnknown

# remove columns we don't need anymore
freq_trigram_separate$w1 <- NULL
freq_trigram_separate$w2 <- NULL
freq_trigram_separate$w3 <- NULL
freq_trigram_separate$w1_inDict <- NULL
freq_trigram_separate$w2_inDict <- NULL
freq_trigram_separate$w3_inDict <- NULL

# now, adding the unknonw word we have duplicate indexes values. Sum over them before proceeding 
freq_trigram_separate_aggr <- aggregate(freq_trigram_separate$frequency, by = list(freq_trigram_separate$w1_idx, 
                                        freq_trigram_separate$w2_idx, freq_trigram_separate$w3_idx), FUN = sum)
colnames(freq_trigram_separate_aggr) <- c("w1_idx", "w2_idx", "w3_idx", "frequency")

# then create a sparse matrix to store trigrams frequencies
indexes <- as.matrix(freq_trigram_separate_aggr[, 1:3])
trigram_sparse <- simple_sparse_array(i = indexes, v = freq_trigram_separate_aggr$frequency, dim=c(NUM_WORDS, NUM_WORDS, NUM_WORDS))

rm(indexes, freq_trigram_all, freq_trigram_separate, freq_trigram_all_thresh, freq_trigram_separate_aggr)

#### QUADGRAM ####
#LOAD DATA FROM DISK
load('/storage/laur/Personal/MasneriStefano/data/freq_4.rda')

# now for the quadgram. first, reduce the number of elements (at least 3 counts)
THRESH_4GRAM = 2
freq_4gram_all_thresh = freq_quadgram_all[freq_quadgram_all$frequency >= THRESH_4GRAM, ]

# split the words in 4-gram
freq_4gram_separate <- separate(freq_4gram_all_thresh, rn, c("w1", "w2", "w3", "w4"), sep = " ")

# now we want to convert the words into indexes
freq_4gram_separate$w1_idx  <- match(freq_4gram_separate$w1, myDict)
freq_4gram_separate$w2_idx  <- match(freq_4gram_separate$w2, myDict)
freq_4gram_separate$w3_idx  <- match(freq_4gram_separate$w3, myDict)
freq_4gram_separate$w4_idx  <- match(freq_4gram_separate$w4, myDict)

# it may happen that we have a not exact match, so take care of it.
freq_4gram_separate$w1_inDict <- freq_4gram_separate$w1 %in% myDict
freq_4gram_separate$w2_inDict <- freq_4gram_separate$w2 %in% myDict
freq_4gram_separate$w3_inDict <- freq_4gram_separate$w3 %in% myDict
freq_4gram_separate$w4_inDict <- freq_4gram_separate$w4 %in% myDict

# remove the lines where the last word is not in dictionary
freq_4gram_separate <- freq_4gram_separate[freq_4gram_separate$w4_inDict]

# Then, replace words not in the dictionary with the index of unknown word
freq_4gram_separate$w1_idx[!freq_4gram_separate$w1_inDict] <- idxUnknown
freq_4gram_separate$w2_idx[!freq_4gram_separate$w2_inDict] <- idxUnknown
freq_4gram_separate$w3_idx[!freq_4gram_separate$w3_inDict] <- idxUnknown
freq_4gram_separate$w4_idx[!freq_4gram_separate$w4_inDict] <- idxUnknown

# replace also NAs with the index for unknown word
freq_4gram_separate$w1_idx[is.na(freq_4gram_separate$w1_idx)] <- idxUnknown
freq_4gram_separate$w2_idx[is.na(freq_4gram_separate$w2_idx)] <- idxUnknown
freq_4gram_separate$w3_idx[is.na(freq_4gram_separate$w3_idx)] <- idxUnknown
freq_4gram_separate$w4_idx[is.na(freq_4gram_separate$w4_idx)] <- idxUnknown

# remove columns we don't need anymore
freq_4gram_separate$w1 <- NULL
freq_4gram_separate$w2 <- NULL
freq_4gram_separate$w3 <- NULL
freq_4gram_separate$w4 <- NULL
freq_4gram_separate$w1_inDict <- NULL
freq_4gram_separate$w2_inDict <- NULL
freq_4gram_separate$w3_inDict <- NULL
freq_4gram_separate$w4_inDict <- NULL

# now, adding the unknonw word we have duplicate indexes values. Sum over them before proceeding 
freq_4gram_separate_aggr <- aggregate(freq_4gram_separate$frequency, by = list(freq_4gram_separate$w1_idx, 
                              freq_4gram_separate$w2_idx, freq_4gram_separate$w3_idx, freq_4gram_separate$w4_idx), 
                              FUN = sum)
colnames(freq_4gram_separate_aggr) <- c("w1_idx", "w2_idx", "w3_idx", "w4_idx", "frequency")

# then create a sparse matrix to store 4-grams frequencies
indexes <- as.matrix(freq_4gram_separate_aggr[, 1:4])
quadgram_sparse <- simple_sparse_array(i = indexes, v = freq_4gram_separate_aggr$frequency, dim=c(NUM_WORDS, NUM_WORDS, NUM_WORDS, NUM_WORDS))

rm(freq_quadgram_all, freq_4gram_separate, freq_4gram_all_thresh, freq_4gram_separate_aggr)

# SAVE NECESSARY STUFF
save(myDict, freq_unigram_all_thresh_sorted, file = '/storage/laur/Personal/MasneriStefano/data/singleWordsInfo.rda')
save(bigram_sparse, trigram_sparse, quadgram_sparse, file = '/storage/laur/Personal/MasneriStefano/data/sparseMatrices.rda')