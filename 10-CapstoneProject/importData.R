importData <- function(dirname) {
  blogFile <- paste0(dirname, 'en_US.blogs.txt')
  newsFile <- paste0(dirname, 'en_US.news.txt')
  twitFile <- paste0(dirname, 'en_US.twitter.txt')
  blog <- readLines(blogFile, encoding = 'UTF-8', skipNul = TRUE)
  news <- readLines(newsFile, encoding = 'UTF-8', skipNul = TRUE)
  twit <- readLines(twitFile, encoding = 'UTF-8', skipNul = TRUE)

  #REMOVE NON ENGLISH CHARACTERS
  blog <- iconv(blog, "latin1", "ASCII", sub="")
  news <- iconv(news, "latin1", "ASCII", sub="")
  twit <- iconv(twit, "latin1", "ASCII", sub="")
  allData = list(blog, news, twit)
  allData
}
