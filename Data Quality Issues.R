#FINDING DATA QUALITY ISSUES


install.packages("jsonlite")
library("jsonlite")

library("ggplot2")

#Loading JSON file
#Users data
users_data <- stream_in(file("C:/Users/akhil/Downloads/data/users.json.gz"))

summary(users_data)
head(users_data)

str(users_data)

is.na(users_data)
sum(is.na(users_data$id))

names(users_data)[names(users_data) == "_id.$oid"] <- "id"

##Checking for duplicates in the ID column
sum(duplicated(users_data$id))

# list rows of data that have missing values
users_data[!complete.cases(users_data),]


#Receipts data
#Loading JSON file
receipts_data <- stream_in(file("C:/Users/akhil/Downloads/data/receipts.json.gz"))

summary(receipts_data)
tail(receipts_data)


is.na(receipts_data)
sum(is.na(receipts_data))

str(receipts_data) #data types of columns


names(receipts_data)[names(receipts_data) == "_id.$oid"] <- "r.id"

##Checking for duplicates in the ID column
sum(duplicated(receipts_data$r.id))

#Brands data
#Loading JSON file
brands_data <- stream_in(file("C:/Users/akhil/Downloads/data/brands.json.gz"))

head(brands_data)
summary(brands_data)

is.na(brands_data)
sum(is.na(brands_data))

str(brands_data) #data types of columns

##Checking for duplicates in the ID column

names(brands_data)[names(brands_data) == "_id.$oid"] <- "b.id"

sum(duplicated(brands_data$b.id))

## ***DATA QUALITY ISSUES OBSERVED***:

#1. In the brands table, the brand code column has 
# different data type of entries. Some are string and some are numeric. 

#2. There's duplicates in two different columns so what's the 
#significance of the two columns. For example name and brand code 
#column have a lot of same entries like test brand @1607639232356.

#3. There are a lot of missing entries in columns in all three tables.

