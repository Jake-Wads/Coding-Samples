#
#   CIS*3190 Assignment #4
#
#      Name: e Calculator
#      Author: Jacob Wadsworth
#      Date of Last Revision: April 8, 2022
#      Summary: This program calculates e to n given decimal places
#

import sys
import math
import array as arr

# calculate the Value of e to n digits and return it in a int array
def calculate_e(n):
    m = 4
    test = (n + 1) * 2.30258509
    coef = [0 for i in range(10000)]
    eList = [0 for i in range(10000)]

    # calculate value of m
    while m * (math.log(m) - 1.0) + 0.5 * math.log(6.2831852 * m) < test:
        m = m + 1

    # set coef values to 1
    for j in range(2, m+1):
        coef[j] = 1

    # set first value to 2
    eList[0] = 2

    # calculate values and store them in eList
    for i in range(1, n+1):
        carry = 0

        for j in range(m, 1, -1):
            temp = int(coef[j] * 10 + carry)
            carry = int(temp / j)
            coef[j] = int(temp - carry * j)

        eList[i] = carry

    return eList

# write the value of e to a file
def keepe(eList, filename, n):
    f = open(filename, 'w')

    # print out e to file
    f.write(str(eList[0]))
    f.write(".")
    for i in range(1, n):
        f.write(str(eList[i]))

    # close file
    f.close()

# get input until input is int
while True:
    print("How many digits would you like to calculate?")
    n = input()
    if n.isdigit():
        break
n = int(n)

# get filename
print("Please enter a filename to store the value of e")
filename = input()

# define the list
eList = arr.array('i')

# calculate e
eList = calculate_e(n)

# save e to file
keepe(eList, filename, n)
