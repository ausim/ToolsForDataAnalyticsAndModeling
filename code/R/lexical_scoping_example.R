#
# Lexical Scoping Example - Clear the environment before experimenting --->
#
# See https://bookdown.org/rdpeng/rprogdatascience/scoping-rules-of-r.html for more details
# This site has a nice video in addition to the text.
#

# Note that a is defined inside the function, y is used,
# but not defined or passed as an argument, z is defined
# and returned.
my_fun <- function(x) {
  a = "dog"
  z = x+y
  print(ls())
  return(z)
}

# x is passed in and a and z are defined in the function.  Where
# does y come from in the function?  In this case, y is a
# free variable.  Lexical scoping - look in
# the environment where the function is defined.

# note that the a and Z variables defined in the function
# aren't in the environment.
y = 207
b = my_fun(13)
print(ls())

