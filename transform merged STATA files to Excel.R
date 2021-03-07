

library(haven)
#Transform STATA data files to Excel
#Train data
X <- read_dta("C:/Users/yunan/Downloads/York U/Machine Learning Cert/Assignment 3/data/orders_TRAIN_products_MERGED.dta")

X=as.data.frame(X)

write.csv(X,"C:/Users/yunan/Downloads/York U/Machine Learning Cert/Assignment 3/data/orders_TRAIN_products_MERGED.csv", row.names = F)


#Prior data
X <- read_dta("C:/Users/yunan/Downloads/York U/Machine Learning Cert/Assignment 3/data/orders_PRIOR_products_MERGED.dta")

X=as.data.frame(X)

write.csv(X,"C:/Users/yunan/Downloads/York U/Machine Learning Cert/Assignment 3/data/orders_PRIOR_products_MERGED.csv", row.names = F)


########################################################################
# order_products_train data
X<- read_dta("C:/Users/yunan/Downloads/York U/Machine Learning Cert/Assignment 3/data/order_products_train_product name_aisle_department_MERGED.dta")

X=as.data.frame(X)

write.csv(X,"C:/Users/yunan/Downloads/York U/Machine Learning Cert/Assignment 3/data/order_products_train_product name_aisle_department_MERGED.csv", row.names = F)


# order_products_prior data
X<- read_dta("C:/Users/yunan/Downloads/York U/Machine Learning Cert/Assignment 3/data/order_products_prior_product name_aisle_department_MERGED.dta")

X=as.data.frame(X)

write.csv(X,"C:/Users/yunan/Downloads/York U/Machine Learning Cert/Assignment 3/data/order_products_prior_product name_aisle_department_MERGED.csv", row.names = F)

