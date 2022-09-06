/*
 *   CIS*3190 Assignment #4
 *
 *      Name: e Calculator
 *      Author: Jacob Wadsworth
 *      Date of Last Revision: April 8, 2022
 *      Summary: This program calculates e to n given decimal places
 *
 */

#include <stdio.h>       /* Input/Output */
#include <stdlib.h>      /* General Utilities */
#include <math.h>        /* Input/Output */
#include <ctype.h>       /* Check Types */

//Calculate the Value of e to n digits and return it in a int array
int* calculate_e(int n) {

    int* eList = malloc((n+1) * (sizeof(int)));
    int m = 4;
    float test = (n+1) * 2.30258509;
    int i, j, carry, temp;

    //calculate value of m
    while (m * (log(m) - 1.0) + 0.5 * log(6.2831852 * m) < test) {
        m = m + 1;
    }

    //allocate enough memory for coef from m
    int* coef = malloc((m+1) * (sizeof(int)));

    //set coef values to 1
    for (j = 2; j <= m; j++) {
        coef[j] = 1;
    }

    //set first value to 2
    eList[0] = 2;

    //calculate values and store them in eList
    for (i = 1; i <= n; i++) {
        carry = 0;

        for (j = m; j >= 2; j--) {
            temp = coef[j] * 10 + carry;
            carry = temp / j;
            coef[j] = temp - carry * j;
        }
        eList[i] = carry;
    }

    //free the coef array
    free(coef);

    return eList;
}

//write the value of e to a file
void keepe(int* eList, char* filename, int n) {
    //open file for writing
    FILE *file = fopen(filename, "w");

    //print out e into file
    int i;
    fprintf(file, "%d", eList[0]);
    fprintf(file, ".");
    for (i = 1; i < n; i++) {
        fprintf(file, "%d", eList[i]);
    }

    //close file
    fclose(file);

}

//main function
int main ( int argc, char* argv[] ) {
    int n;
    char* input = malloc(sizeof(char) * 50);
    char* filename = malloc(sizeof(char) * 100);
    
    //get input until input is int
    do {
        printf("How many digits would you like to calculate?\n");
        fgets(input, sizeof(input), stdin);
    } while (isdigit(*input) == 0);
    n = atoi(input);    

    //get filename
    printf("Please enter a filename to store the value of e\n");
    scanf("%s", filename);

    //calculate e
    int* eEst = calculate_e(n);

    //save e to file
    keepe(eEst, filename, n);

    //free memory
    free(eEst);
    free(filename);
    free(input);

}