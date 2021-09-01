# -*- coding: utf-8 -*-
"""
Companion to the Jupyter Notebook "1.1 Python Lists and Dictionaries.ipynb"
Created on Sun Aug 29 06:49:25 2021

@author: jsmith
"""

#%%
# Define a list and then show the list.  Note that the list contains objects of 
# different types (ints, floats, strings).
l1 = [1, 2, 3, 17.24, 967, 45, "dog", 'cat', [1, 2, 3], {'one':1, 'two':2}]

#%%
for item in l1:
    print(item)
    
#%%
for j in range(len(l1)):
    print(l1[j])

#%%
# List slicing - as with string slicing, the slice 
# icludes elements i, i+1, i+2, up to, but not including j (and is a separate list)
l2 = l1[2:6]

#%%
# contatenation
l3 = l1 + l2 + [86.4, 91.8, 'pony']

#%%
# repetition
l4 = l3[:3]*3


#%%
# Nested lists - this is a "list of lists."
l2 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

#%%
## Lists and mutability
##
# Create a list and assign two references to that list
l1 = [1, 2, 3]
l2 = l1
l1, l2

#%%
# Update the first element of l1
l1[0] = "The dog ate my homework."

#%%
# compare to the similar actions with simple objects (which are immutable)
x = 123
y = x

#%%
x = "The dog ate my homework."

#%%
# Suppose you'd like to estimate the probability of rolling a '7' ...
#  (true prob. is 6/36=.1667)
import numpy as np
obs = 50000
p = len([r for r in [np.random.randint(1, 7, 2) for i in range(obs)] if sum(r) == 7])/obs

print("Estimate or prob. based on {:,d} samples: {:.4f}".format(obs,p))
#%%
# creating a list to define a person
person = ["Tom Howard", 54, 6.0]

# creating a list of lists to define a team
people = [
    ["Tom Howard",          54,  6.0],
    ["Jane Grimm",          19,  4.9],
    ["Sam Brown",           25,  6.2],
    ["Sarah Joan Spade",    26, 5.25],
    ["Blaine Jones",        62,  5.8],
    ["Devin Callahan",      32, 5.92],
]

#%%
# Using a more human-friendly format
"The average age of the team members is {:.1f} years.".format(
    sum([p[1] for p in people])/float(len(people))
)
# Created an anoymous object, but did nothing with it.  Note
# the difference between what you see in Sypder and what you
# see in Jupyter Lab/Notebook for this same expression.

#%%
print("The average age of the team members is {:.1f} years.".format(
    sum([p[1] for p in people])/float(len(people))
))

#%%
# Nested dictionaries
s1 = {
    'Jane Doe'   : {'ID':'b0001','Gender': 'F','HW1':95,'HW2':87, 'HW3':92,'Exam1': 88,'Exam2':93,'FinalExam':90},
    'John Blue'  : {'ID':'b0002','Gender': 'M','HW1':55,'HW2':76, 'HW3':89,'Exam1': 77,'Exam2':82,'FinalExam':80},
    'Kim Tester' : {'ID':'b0003','Gender': 'F','HW1':80,'HW2':75, 'HW3':65,'Exam1': 70,'Exam2':75,'FinalExam':80},
    'Larry Black': {'ID':'b0004','Gender': 'M','HW1':90,'HW2':90, 'HW3':92,'Exam1': 95,'Exam2':85,'FinalExam':94},
    'Susan White': {'ID':'b0005','Gender': 'F','HW1':65,'HW2':52, 'HW3':85,'Exam1': 45,'Exam2':80,'FinalExam':82}
    }

#%% 
# List of dictionaries
s2 = [
    {'Name':'Jane Doe',    'ID':'b0001','Gender': 'F','HW1':95,'HW2':87, 'HW3':92,'Exam1': 88,'Exam2':93,'FinalExam':90},
    {'Name':'John Blue',   'ID':'b0002','Gender': 'M','HW1':55,'HW2':76, 'HW3':89,'Exam1': 77,'Exam2':82,'FinalExam':80},
    {'Name':'Kim Tester',  'ID':'b0003','Gender': 'F','HW1':80,'HW2':75, 'HW3':65,'Exam1': 70,'Exam2':75,'FinalExam':80},
    {'Name':'Larry Black', 'ID':'b0004','Gender': 'M','HW1':90,'HW2':90, 'HW3':92,'Exam1': 95,'Exam2':85,'FinalExam':94},
    {'Name':'Susan White', 'ID':'b0005','Gender': 'F','HW1':65,'HW2':52, 'HW3':85,'Exam1': 45,'Exam2':80,'FinalExam':82}
    ]


#%%
# List of lists
s3 = [
    ['Jane Doe',    'b0001', 'F', 95, 87, 92, 88, 93, 90],
    ['John Blue',   'b0002', 'M', 55, 76, 89, 77, 82, 80],
    ['Kim Tester',  'b0003', 'F', 80, 75, 65, 70, 75, 80],
    ['Larry Black', 'b0004', 'M', 90, 90, 92, 95, 85, 94],
    ['Susan White', 'b0005', 'F', 65, 52, 85, 45, 80, 82]
    ]

#%%
# compare retrieving the final exam scores:

# Nested dictionaries
fe1 = [s1[k]['FinalExam'] for k in s1]

# List of dictionaries
fe2 = [s['FinalExam'] for s in s2]

# list of lists
fe3 = [r[8] for r in s3]

# Note -- none of these is "right" or "wrong" -- these are three different
# data structures for the exact same data.  Each has benefits
# depending on useage.
