rm(list=ls(all=TRUE))

library("proxy")
library('tm')
library('class')
library('utils')

setwd("D:\\project_tm\\R\\wd\\authorship ascription\\Miningcorpus")

doyle <- Corpus(DirSource('doyle'), readerControl = list(reader=readPlain))

dumas <- Corpus(DirSource('dumas'), readerControl = list(reader=readPlain))

wells <- Corpus(DirSource('wells'), readerControl = list(reader=readPlain))

#doyle_dtm <- DocumentTermMatrix(doyle, list(weighting = weightTfIdf))
##par(mfrow=c(2,1))
#Zipf_plot(doyle_dtm,type='o',col='red',main = 'Zipf Law',ylab = 'Log of Frequency', xlab='Log of Rank')
#Heaps_plot(doyle_dtm,type='o',col='blue',main = 'Heap Law',ylab = 'Log of Vocabulary', xlab='Log of Text size')

#dumas_dtm <- DocumentTermMatrix(dumas, list(weighting = weightTfIdf))\
##par(mfrow=c(2,1))
#Zipf_plot(dumas_dtm,type='o',col='red',main = 'Zipf Law',ylab = 'Log of Frequency', xlab='Log of Rank')
#Heaps_plot(dumas_dtm,type='o',col='blue',main = 'Heap Law',ylab = 'Log of Vocabulary', xlab='Log of Text size')

#wells_dtm <- DocumentTermMatrix(wells, list(weighting = weightTfIdf))
##par(mfrow=c(2,1))
#Zipf_plot(wells_dtm,type='o',col='red',main = 'Zipf Law',ylab = 'Log of Frequency', xlab='Log of Rank')
#Heaps_plot(wells_dtm,type='o',col='blue',main = 'Heap Law',ylab = 'Log of Vocabulary', xlab='Log of Text size')

doyle_corpus <- data.frame(matrix(doyle[1:150]),row.names=NULL)
dumas_corpus <- data.frame(matrix(dumas[1:150]),row.names=NULL)
wells_corpus <- data.frame(matrix(wells[1:150]),row.names=NULL)

colnames(doyle_corpus) <- "corpus"
colnames(dumas_corpus) <- "corpus"
colnames(wells_corpus) <- "corpus"


mining_corpus <- Corpus(DataframeSource(rbind(doyle_corpus,dumas_corpus,wells_corpus)))

f_corpus <- tm_map(mining_corpus, removeWords, stopwords("english"))
#View(f_corpus[1:1])

f_corpus <- tm_map(f_corpus , stripWhitespace)
#View(f_corpus[1:1])

dtm <- DocumentTermMatrix(f_corpus, list(weighting = weightTfIdf))
dtm <- removeSparseTerms(dtm, 0.995)

#inspect(removeSparseTerms(dtm, 0.99))

#tdm <- TermDocumentMatrix(f_corpus, list(weighting = weightTfIdf))
#tdm <- removeSparseTerms(tdm, 0.5)

#par(mfrow=c(2,1))
#Zipf_plot(dtm,type='o',col='red',main = 'Zipf Law',ylab = 'Log of Frequency', xlab='Log of Rank')
#Heaps_plot(dtm,type='o',col='blue',main = 'Heap Law',ylab = 'Log of Vocabulary', xlab='Log of Text size')

#par(mfrow=c(2,1))
#Zipf_plot(tdm,type='o',col='red',main = 'Zipf Law',ylab = 'Log of Frequency', xlab='Log of Rank')
#Heaps_plot(tdm,type='o',col='blue',main = 'Heap Law',ylab = 'Log of Vocabulary', xlab='Log of Text size')

#View(as.matrix(dtm))

a <- data.frame(inspect(dtm))

class=as.factor(c(rep(1,150),rep(2,150),rep(3,150)))

b <- data.frame(cbind(class,a))

b_train <-  data.frame((rbind(b[1:100,],b[151:250,],b[301:400,])))
b_test  <-  data.frame(rbind(b[101:150,],b[251:300,],b[401:450,]))

library(RWeka)
dtC45= J48(class ~ ., data = b_train)
summary(dtC45)

library("partykit")
plot(as.party(dtC45))

a=table(b_test$class, predict(dtC45,b_test))
accuc45 <- sum(diag(a))/sum(a)*100
recall <- ((a[1,1]+a[1,2]+a[1,3])/sum(a)) * 100

a

library(evtree)

set.seed(2414)

evDt6 <- evtree(class ~ ., data = b_train, minsplit=25, minbucket = 12, maxdepth = 15)

#plot(evDt6)

a <- table(b_train$class, predict(evDt6))
accuEv=sum(diag(a))/sum(a)*100

a=table(b_test$class, predict(evDt6,b_test))

accuE=sum(diag(a))/sum(a)*100