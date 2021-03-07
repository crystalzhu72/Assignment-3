

*merge products & aisles & departments together
*products data set
import delimited "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\Raw\products.csv", case(preserve) clear 
save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\Raw\products.dta"

*aisles data set
import delimited "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\Raw\aisles.csv", case(preserve) clear 
save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\Raw\aisles.dta"

*departments data set
import delimited "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\Raw\departments.csv", case(preserve) clear 
save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\Raw\departments.dta"

*merge products with aisles together
use "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\Raw\products.dta", replace

sort aisle_id
merge m:1 aisle_id using "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\Raw\aisles.dta"
*all matched!
drop _merge

*merge with departments
sort department_id
merge m:1 department_id using "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\Raw\departments.dta"
*all matched!
drop _merge

order product_name aisle department

sort product_id
order product_id product_name aisle department

quietly by product_id: gen dup=cond(_N==1, 0,_n)
tab dup
*no duplicated products
*49,688 unique products, with their aisle and department information
drop dup


save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\products_aisle_department_MERGED.dta", replace


***********************************************************************************
**** ADD PRODUCTS INFO TO ORDERS_PRODUCTS_TRAIN & PRIOR (BASED ON PRODUCT ID) *****************
***********************************************************
*the order_products_train dataset
import delimited "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\order_products__train.csv", case(preserve) clear

save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\order_products_train.dta", replace

sort product_id
merge m:1 product_id using "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\products_aisle_department_MERGED.dta"
*some products info not used (those products not in the train order dataset)
drop if _merge==2
drop _merge

save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\order_products_train_product name_aisle_department_MERGED.dta", replace


****************************************************************
*the order_products_priot dataset
import delimited "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\order_products__prior.csv", case(preserve) clear

save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\order_products_prior.dta", replace

sort product_id
merge m:1 product_id using "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\products_aisle_department_MERGED.dta"
*11/32,434,489 products info not used (those products not in the train order dataset)
drop if _merge==2
drop _merge

save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\order_products_prior_product name_aisle_department_MERGED.dta", replace


**************************************************************************************************
***Then merge order_product_train & priot back to the orders data, based on order_id
*the test dataset would have product info missing (I guess this is the dataset Kaggle use to calculate scores?)
*so maybe we can drop test data for now from the orders dataset?
import delimited "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\orders.csv", case(preserve) clear 

sort order_id
quietly by order_id: gen dup=cond(_N==1, 0,_n)
tab order_id
*no dup order_id - orders are all unique! (but one order will have multiple products!)
drop dup

save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\orders.dta", replace

************************************************************************
*merge train dataset product info back to the orders data first
use "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\orders.dta", replace

merge 1:m order_id using "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\order_products_train_product name_aisle_department_MERGED.dta"
sort order_id

tab _merge if eval_set=="train"
*all train orders are matched

keep  if eval_set=="train"

sort order_id

save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\orders_TRAIN_products_MERGED.dta", replace


*********************************************************************************************
*merge prior dataset product info back to the orders data first
use "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\orders.dta", replace

keep  if eval_set=="prior"

merge 1:m order_id using "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\order_products_prior_product name_aisle_department_MERGED.dta"

sort order_id

tab _merge if eval_set=="prior"
*all train orders are matched



sort order_id

save "C:\Users\yunan\Downloads\York U\Machine Learning Cert\Assignment 3\data\orders_TRAIN_products_MERGED.dta", replace




