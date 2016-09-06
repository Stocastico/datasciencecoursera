#LOAD LIBRARIES AND IMPORT DATA
library(NLP)
library(tm)
library(SnowballC)
library(ggplot2)
library(wordcloud)
library(stringi)
library(slam)

#IMPORT DATA
direcname = "/Users/stefano/CourseraSwiftKey/en_US/"
dir(direcname)
blogFile <- paste0(direcname, 'en_US.blogs.txt')
newsFile <- paste0(direcname, 'en_US.news.txt')
twitFile <- paste0(direcname, 'en_US.twitter.txt')
blog <- readLines(blogFile, encoding = 'UTF-8', skipNul = TRUE)
news <- readLines(newsFile, encoding = 'UTF-8', skipNul = TRUE)
twit <- readLines(twitFile, encoding = 'UTF-8', skipNul = TRUE)

#REMOVE NON ENGLISH CHARACTERS
blog <- iconv(blog, "latin1", "ASCII", sub="")
news <- iconv(news, "latin1", "ASCII", sub="")
twit <- iconv(twit, "latin1", "ASCII", sub="")
allData = list(blog, news, twit)

#FOR REPRODUCIBILITY
set.seed(20160902)

#GET BASIC INFO ON THE DOCUMENTS
filenames = c(basename(blogFile), basename(newsFile), basename(twitFile))
sizes = c(file.info(blogFile)$size, file.info(newsFile)$size, file.info(twitFile)$size ) / (1024*1024)
numLines = (sapply(allData, length))
numWords = (sapply(allData, stri_stats_latex)['Words',])
wordFreq = t(sapply(allData, function(x) summary(stri_count_words(x))[c('Min.', 'Mean', 'Max.')]))
colnames(wordFreq) = c('Min_words', 'Avg_words', 'Max_words')

fileInfo <- data.frame(
  'name' = filenames,
  'size_MBytes' = sizes,
  'Num_lines' = numLines,
  'Num_words' = numWords,
  wordFreq
)

#SAMPLING THE INPUT DATA
samplingFrac <- 0.05
subsetBlog <- blog[1 == rbinom(length(blog), 1, samplingFrac)]
subsetNews <- news[1 == rbinom(length(news), 1, samplingFrac)]
subsetTwit <- twit[1 == rbinom(length(twit), 1, samplingFrac)]
subsetAllData <- c(subsetBlog, subsetNews, subsetTwit)
#CREATE THE CORPUS
docs <- Corpus(VectorSource(subsetAllData))

# DATA PROPEROCESSING
# remove punctuation
docs <- tm_map(docs, removePunctuation)
#remove numbers
docs <- tm_map(docs, removeNumbers)
#convert to lowercase
docs <- tm_map(docs, tolower)
#remove stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
#strip whitespace
docs <- tm_map(docs, stripWhitespace)
#treat as text
docs <- tm_map(docs, PlainTextDocument)

# DATA STAGING

#create a document term matrix and a term document matrix
dtm_unigram <- DocumentTermMatrix(docs)
tdm_unigram <- TermDocumentMatrix(docs)
# do the same for 2-gram and 3-gram
BigramTokenizer <- function(x) unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
TrigramTokenizer <- function(x) unlist(lapply(ngrams(words(x), 3), paste, collapse = " "), use.names = FALSE)
tdm_bigram <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
tdm_trigram <- TermDocumentMatrix(docs, control = list(tokenize = TrigramTokenizer))
dtm_bigram <- DocumentTermMatrix(docs, control = list(tokenize = BigramTokenizer))
dtm_trigram <- DocumentTermMatrix(docs, control = list(tokenize = TrigramTokenizer))

# DATA EXPLORATION FOR SINGLE WORDS
# ORGANIZE TERMS BY FREQUENCY
freq <- col_sums(dtm_unigram)
length(freq)
ord <- order(freq)

# remove sparse terms
dtms <- removeSparseTerms(dtm_unigram, 0.1)

# word frequencies
freq[head(ord, 10)]
freq[tail(ord, 10)]
head(table(freq), 20)
tail(table(freq), 20)

# terms which appear frequently
minFreqUnigrams = 5000
wf <- data.frame(word=names(freq), freq=freq)
#wf <- findFreqTerms(dtm_unigram, lowfreq=minFreqUnigrams)

#plots
p <- ggplot(subset(wf, freq>minFreqUnigrams), aes(word, freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p

# Word clouds
wordcloud(names(freq), freq, min.freq=5000, scale=c(5, .1), max.words=50, colors=brewer.pal(6, "Dark2"))

# Computing bigrams and trigrams
minFreqBigram <- 500
minFreqTrigram <- 50
freqBi <- col_sums(dtm_bigram)
freqTri <- col_sums(dtm_trigram)
ordBi <- order(freqBi)
ordTri <- order(freqTri)
freqBi[tail(ordBi, 10)]
freqTri[tail(ordTri, 10)]
bf <- data.frame(bigrams=names(freqBi), freq=freqBi)
tf <- data.frame(trigrams=names(freqTri), freq=freqTri)

p <- ggplot(subset(bf, freq>minFreqBigrams), aes(reorder(bigrams, freq), freq))
p <- p + geom_bar(stat="identity", fill="indianred1")
p <- p + labs(title="Most Common Bigrams", x="Bigrams", y="Frequency")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p

p <- ggplot(subset(tf, freq>minFreqTrigrams), aes(reorder(trigrams, freq), freq))
p <- p + geom_bar(stat="identity", fill="aquamarine4" )
p <- p + labs(title="Most Common Trigrams", x="Trigrams", y="Frequency")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p
