# -*- coding: utf-8 -*-
"""
Created on Wed Sep 23 07:06:16 2020

@author: jsmith
"""
# %%
import pandas as pd
import os

# show - displays the Pandas object 
def show(data, show_data = 0):
    print ("   Type: {:}".format(type(data)))
    print ("  Index: {:}".format(data.index))
    print ("Columns: {:}".format(data.columns))
    print ("  Shape: {:}".format(data.shape))
    if show_data:
        print(data.values)

print("Pandas version: {:}".format(pd.__version__))
print("Curret working directory: {:}".format(os.getcwd()))
print("Verify the working directory -- might need to update the file path.")

# Some sample datasets - all from the source above.
# Dictionary - key:actual file name
fnames = {
     "cities"    :"01_U.S._Top_25_Largest_Cities.csv"
    ,"airports"  :"02_Airport_Codes_mapped_to_Latitude_Longitude_in_the_United_States.csv"
    ,"starbucks" :"03_All_Starbucks_Locations_in_the_US_-_Map.csv"
    ,"scpay"     :"04_South_Carolina_State_Employee_Salary_Database.csv"
    ,"songs"     :"05_Top_1_000_Songs_To_Hear_Before_You_Die.csv"
    ,"bestcos"   :"06_Top_5_000_Companies_from_INC.com.csv"
    ,"accounts"  :"07_Unclaimed_bank_accounts.csv"
    ,"wh2012"    :"08_2012_Annual_Report_to_Congress_on_White_House_Staff.csv"
    ,"washconst" :"09_Completed_Construction_Projects_2005_in_Washington_DC.csv"
    ,"usecon"    :"10_us_economic_data.csv"
    ,"matches"   :"11_matches.csv"
    ,"meals"     :"12_meals.csv"
    ,"ervs"      :"13_erv.csv"
    ,"fexchange" :"14_Foreign_Exchange_Rates.csv"
    ,"gmobility" :"15_Global_Mobility_Report.csv"
    ,"shoppers"  :"16_online_shoppers_purchasing_intention.csv"
}

# %%
# Grab a data set using the key and show the first few rows
fkey = "cities"
fpath = "data/"
df = pd.read_csv(fpath+fnames[fkey])
show(df)

# %%
for col in df.columns:
    print ("{:} ({:})".format(col,df[col].dtype))
    
# %%


