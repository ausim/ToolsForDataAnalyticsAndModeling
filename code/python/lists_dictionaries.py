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











