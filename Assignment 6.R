library(dplyr)
library(tidyr)
library(zoo)

# 1 & 2
fx <- read.csv("fx.csv", header = FALSE, na.string="-")
fx <- fx %>% select(-(obs..status:Calculation.end.date))
new <- c(1)
fx$new <- new
remove(new)
colnames(fx) <- c("Date", "USD/EURO", "Exchange Rate Return")

summary(fx)
## To remove unnecessary dates to avoid mismatch in info in terms of dates for Fx and Speeches
fx <- fx[-c(1:30),]
row.names(fx) <- NULL
fx[fx =="-"]<- NA
fx$Date <- as.factor(fx$Date)
fx$`USD/EURO` <- as.numeric(fx$`USD/EURO`)
summary(fx)

options(max.print = 100000)

# 3
## Using Zoo package to handle NA obs for USD/EURO
## Fromlast = TRUE causes it to be next observation carried backwards otherwise prev observation carried forward
fx$`USD/EURO` <- na.locf((fx$`USD/EURO`), fromLast = TRUE)

df1 <- fx$`USD/EURO`
i <- 1:5899
df1[i] <- ((df1[i]/df1[i+1])-1)*100
  
fx$'Exchange Rate Return' <- df1
fx[,'Exchange Rate Return']=round(fx[,'Exchange Rate Return'],4)

fx$'Exchange Rate Return' <- c((diff(fx$`USD/EURO`)*(-1))/fx$`USD/EURO`[-1], NA)

# 4
fx = fx %>% 
  mutate(good_data = ifelse(fx$`Exchange Rate Return` > "0.5", 1, 0)) %>%
  mutate(bad_data = ifelse(fx$`Exchange Rate Return` > "-0.5" & fx$`Exchange Rate Return` < "0", 1, 0))

## To remove percentages, as.numeric(sub("%", "", df1)) if needed

speeches <- read.csv("speeches.csv", sep = '|', quote = "", encoding="UTF-8")
speeches <- speeches[!is.na(speeches$contents),c('date','contents')]
colnames(speeches) <- c("Date","Contents")
speeches <- speeches %>%
  group_by(date) %>%
  summarise(contents=paste(contents,collapse = ""))

# 5
fx$Date <- as.character(fx$Date)
df <- fx %>% left_join(speeches, by= 'Date')
str(df)

stop_words <- read.csv("stop_words_english.txt", header = FALSE)[,1]
stop_words

library(text2vec)

good_news_contents <- fx$good_news==1
bad_news_contents <- fx$bad_news==1
str(fx)

get_word_freq <- function(contents, stop_words, num_words) {
  # Turns a paragraph into a vector of words
  words <- unlist(lapply(contents, word_tokenizer))
  # Turns all words to lowercase
  words <- tolower(words)
  # Find out the number of appearances of each word
  freq <- table(words)
  # Removing stop words
  freq <- freq[!(names(freq) %in% stop_words)]
  # Sort the words from appearing most to least and return the result
  freq <- sort(freq, decreasing=TRUE)
}

good_indicators <- get_word_freq(good_news_contents, stop_words, num_words = 20)
good_indicators

bad_indicators <- get_word_freq(bad_news_contents, stop_words, num_words = 20)
bad_indicators

library(textstem)

#add lemmatization step to the word counter function
get_word_freq_lemmatize <- function(contents, stop_words, num_words) {
  # turn a paragraph to a vector of words
  words <- unlist(lapply(contents, word_tokenizer))  
  # turn all words to lowercase
  words <- tolower(words)  
  # lemmatize words
  words <- lemmatize_words(words)
  # find out the number of appearance of each word
  freq <- table(words)
  # remove the stop words
  freq <- freq[!(names(freq) %in% stop_words)]
  # sort the words from appearing most to least and return result
  freq <- sort(freq, decreasing=TRUE)
  return(names(freq)[1:num_words])
  #names(freq[order(-freq)])[1:num_words] #another way to do this
}

good_indicators2 <- get_word_freq_lemmatize(good_news_contents, stop_words, num_words=20)
good_indicators2

bad_indicators2 <- get_word_freq_lemmatize(bad_news_contents, stop_words, num_words=20)
bad_indicators2

