#ASSUME DATA HAS BEEN LÖOADED FROM DISK
#load('/storage/laur/Personal/MasneriStefano/data/freq_123.rda')

# required libraries
library(triebeard)
library(slam)
library(Matrix)
library(dplyr)
library(tidyr)

#### UNIGRAM ####

# reduce number of elements, keep all elements with at least 10 counts
THRESH_UNIGRAM = 50 
freq_unigram_all_thresh = freq_unigram_all[freq_unigram_all$frequency >= THRESH_UNIGRAM, ]

# add symbol for start and end of sentence, will be required later
startSentence = c('<s>', THRESH_UNIGRAM)
endSentence = c('</s>', THRESH_UNIGRAM)
unknown = c('<UNK>', THRESH_UNIGRAM)
freq_unigram_all_thresh <- rbind(freq_unigram_all_thresh, startSentence, endSentence, unknown)
NUM_WORDS <- dim(freq_unigram_all_thresh)[1]

# set frequency as integers, then sort unigrams, and rename rows to go in order
freq_unigram_all_thresh$frequency <- as.integer(freq_unigram_all_thresh$frequency)
freq_unigram_all_thresh_sorted <- freq_unigram_all_thresh[with(freq_unigram_all_thresh, order(-frequency, rn)), ]
row.names(freq_unigram_all_thresh_sorted) <- 1:NUM_WORDS

# create 2 tries with the unigrams. One has the index has values, the other has the frequency
trieIdx <- trie(keys = freq_unigram_all_thresh_sorted$rn, values = as.integer(row.names(freq_unigram_all_thresh_sorted)))
trieFreq <- trie(keys = freq_unigram_all_thresh_sorted$rn, values = freq_unigram_all_thresh_sorted$frequency)

# will be used later
myDict <- freq_unigram_all_thresh$rn # list of available words
idxUnknown <- longest_match(trieIdx, to_match = '<UNK>')
idxStart <- longest_match(trieIdx, to_match = '<s>')
idxEnd <- longest_match(trieIdx, to_match = '</s>')

#### BIGRAM ####

# now for the bigram. first, reduce the number of elements (at least 3 counts)
THRESH_BIGRAM = 3
freq_bigram_all_thresh = freq_bigram_all[freq_bigram_all$frequency >= THRESH_BIGRAM, ]

# split the words in bigram
freq_bigram_separate <- separate(freq_bigram_all_thresh, rn, c("w1", "w2"), sep = " ")

# now we want to convert the words into indexes
freq_bigram_separate$w1_idx  <- longest_match(trie = trieIdx, to_match = freq_bigram_separate$w1)
freq_bigram_separate$w2_idx  <- longest_match(trie = trieIdx, to_match = freq_bigram_separate$w2)

# it may happen that we have a not exact match, so take care of it.
# Then, replace words not in the dictionary with the index of unknown word
freq_bigram_separate$w1_inDict <- freq_bigram_separate$w1 %in% myDict
freq_bigram_separate$w2_inDict <- freq_bigram_separate$w2 %in% myDict
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

#### TRIGRAM ####

# now for the trigram. first, reduce the number of elements (at least 3 counts)
THRESH_TRIGRAM = 2
freq_trigram_all_thresh = freq_trigram_all[freq_trigram_all$frequency >= THRESH_TRIGRAM, ]

# split the words in trigram
freq_trigram_separate <- separate(freq_trigram_all_thresh, rn, c("w1", "w2", "w3"), sep = " ")

# now we want to convert the words into indexes
freq_trigram_separate$w1_idx  <- longest_match(trie = trieIdx, to_match = freq_trigram_separate$w1)
freq_trigram_separate$w2_idx  <- longest_match(trie = trieIdx, to_match = freq_trigram_separate$w2)
freq_trigram_separate$w3_idx  <- longest_match(trie = trieIdx, to_match = freq_trigram_separate$w3)

# it may happen that we have a not exact match, so take care of it.
# Then, replace words not in the dictionary with the index of unknown word
freq_trigram_separate$w1_inDict <- freq_trigram_separate$w1 %in% myDict
freq_trigram_separate$w2_inDict <- freq_trigram_separate$w2 %in% myDict
freq_trigram_separate$w3_inDict <- freq_trigram_separate$w3 %in% myDict
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

#### QUADGRAM ####
#load the data
load('/storage/laur/Personal/MasneriStefano/data/freq_4.rda')

# now for the quadgram. first, reduce the number of elements (at least 3 counts)
THRESH_4GRAM = 2
freq_4gram_all_thresh = freq_quadgram_all[freq_quadgram_all$frequency >= THRESH_4GRAM, ]

# split the words in 4-gram
freq_4gram_separate <- separate(freq_4gram_all_thresh, rn, c("w1", "w2", "w3", "w4"), sep = " ")

# now we want to convert the words into indexes
freq_4gram_separate$w1_idx  <- longest_match(trie = trieIdx, to_match = freq_4gram_separate$w1)
freq_4gram_separate$w2_idx  <- longest_match(trie = trieIdx, to_match = freq_4gram_separate$w2)
freq_4gram_separate$w3_idx  <- longest_match(trie = trieIdx, to_match = freq_4gram_separate$w3)
freq_4gram_separate$w4_idx  <- longest_match(trie = trieIdx, to_match = freq_4gram_separate$w4)

# it may happen that we have a not exact match, so take care of it.
# Then, replace words not in the dictionary with the index of unknown word
freq_4gram_separate$w1_inDict <- freq_4gram_separate$w1 %in% myDict
freq_4gram_separate$w2_inDict <- freq_4gram_separate$w2 %in% myDict
freq_4gram_separate$w3_inDict <- freq_4gram_separate$w3 %in% myDict
freq_4gram_separate$w4_inDict <- freq_4gram_separate$w4 %in% myDict
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