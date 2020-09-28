# -*- coding: utf-8 -*-
"""
Created on Sun Sep 27 09:47:32 2020

@author: jsmith
"""

import pandas as pd

def show(data, show_data = 0):
    print ("   Type: {:}".format(type(data)))
    print ("  Index: {:}".format(data.index))
    print ("Columns: {:}".format(data.columns))
    print ("  Shape: {:}".format(data.shape))
    if show_data:
        print(data.values)

# %%
# Want to read it the data and parse the dates 
df1 = pd.read_csv('data/10_us_economic_data.csv', parse_dates = ['Month'])
for col in df1.columns:
    print ("{:} ({:})".format(col,df1[col].dtype))

# %%
# Months with maximum and minimum jobs added

print(df1[df1.JobsAdded == df1.JobsAdded.max()])
print(df1[df1.JobsAdded == df1.JobsAdded.min()])

