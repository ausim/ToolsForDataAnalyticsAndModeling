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
df1 = pd.read_csv('data/10_us_economic_data.csv', parse_dates = ['Month'], index_col=0)
for col in df1.columns:
    print ("{:} ({:})".format(col,df1[col].dtype))

# %%
# Months with maximum and minimum jobs added

print(df1[df1.JobsAdded == df1.JobsAdded.max()])
print(df1[df1.JobsAdded == df1.JobsAdded.min()])


# %%
# Extract GDP and remove NaNs
g = df1['GDP'].dropna()

# %%
y1 = pd.Series(data = g.iloc[0:4].values, index=['Q1', 'Q2', 'Q3', 'Q4'], name="2008")
y2 = pd.Series(data = g.iloc[4:8].values, index=['Q1', 'Q2', 'Q3', 'Q4'], name ="2009")
y3 = pd.Series(data = g.iloc[8:12].values, index=['Q1', 'Q2', 'Q3', 'Q4'], name = "2010")
y4 = pd.Series(data = g.iloc[12:16].values, index=['Q1', 'Q2', 'Q3', 'Q4'], name ="2011")
y5 = pd.Series(data = g.iloc[16:20].values, index=['Q1', 'Q2', 'Q3', 'Q4'], name = "2012")

# %%
gdp = pd.concat([y1, y2, y3, y4, y5], axis=1)
