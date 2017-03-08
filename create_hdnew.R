#Benjamin Roberts
#benjamin.roberts@helsinki.fi
#08/03/2017

#read Human Development data into R
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
str(hd)
dim(hd)
#hd is an array with 195 rows (countries/regions) and 8 columns/variables. The variables are the components of the Human Development Index, including HDI Rank, Country, HDI, Life Expectancy at Birth, Expected Years of Education, Mean Years of Education, Gross National Income per capita, GNI per capita rank minus HDI rank. 

#renaming variables
library(plyr)
hd<-plyr::rename(hd, c("HDI.Rank"="HDI_Rank", "Country"="Country", "Human.Development.Index..HDI."="HDI", "Life.Expectancy.at.Birth"="life_exp", "Expected.Years.of.Education"="edu_exp", "Mean.Years.of.Education"="edu_mean", "Gross.National.Income..GNI..per.Capita"="GNI","GNI.per.Capita.Rank.Minus.HDI.Rank"="GNIsubHDI"))


library(dplyr)
#creating new variable education index based on the variables mean education and expected education
hd<-mutate(hd, edu_index=(edu_mean+edu_exp)/2)
#selecting the variables I want to remain in the dataset
keep_columns<-c("Country", "HDI", "life_exp", "edu_index", "GNI")
hd<-dplyr::select(hd, one_of(keep_columns))
dim(hd)

#removing regions from data
tail(hd, n=10)
last<-nrow(hd)-7
hd<-hd[1:last,]
dim(hd)

#reading Inequality-Adjusted Human Development data into R
ineq_hd<-read.table("Workbook2.csv", sep=",", header=TRUE)
summary(ineq_hd)
str(ineq_hd)
dim(ineq_hd)
#ineq_hd is an array with 186 rows(countries) and 9 columns/variables. The variables are the components of the Inequality-Adjusted Human Development Index, including HDI Rank, Country name, HDI score, Inequality-Adjusted HDI score, Coefficient of Human Inequality, Inequality in Life Expectancy, Inequality in Education, Inequality in Income, and Gini Coefficient. 

#renaming variables
ineq_hd<-plyr::rename(ineq_hd, c("Rank"="HDI_Rank", "Country"="Country", "HDI"="HDI","Inequality.Adjusted.HDI"="AdjustedHDI","Coefficient.of.Human.Inequality"="ineq_coef", "Inequality.in.Life.Expectancy"="ineq_life", "Inequality.in.Education"="ineq_edu", "Inequality.in.Income"="ineq_income","Gini.Coefficient"="Gini"))

#selecting the variables I want to remain in the dataset
keep_columns1<-c("Country", "HDI", "AdjustedHDI", "ineq_life", "ineq_edu", "ineq_income")
ineq_hd<-dplyr::select(ineq_hd, one_of(keep_columns1))

#joining the hd and ineq_hd datasets using the shared variables Country and HDI
join_by<-c("Country", "HDI")
hdnew<-inner_join(hd, ineq_hd, by=join_by)
str(hdnew)
dim(hdnew)

#changing row numbers to country names and removing the country column
rownames(hdnew)<-hdnew$Country
hdnew<-dplyr::select(hdnew, -Country)
dim(hdnew)
str(hdnew)

library(tidyr)
library(stringr)
#removing commas from the GNI column and changing variable data to numeric
GNIstring<-str_replace(hdnew$GNI, pattern=",", replace="")%>%as.numeric
hdnew<-mutate(hdnew, GNI=GNIstring)
#changing empty data points to NA, and removing countries with missing data from the dataset
hdnew[hdnew==".."]<-NA 
complete.cases(hdnew)
hdnew<-filter(hdnew, complete.cases(hdnew)==TRUE)
dim(hdnew)

#setting working directory and saving dataset as .csv
setwd("~/Documents")
write.csv(hdnew, file="create_hdnew.csv")
hdnew<-read.csv("create_hdnew.csv", row.names=1)
dim(hdnew)
str(hdnew)


