# Day 1
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/1)

## Part 1
The function **rowChecker** iterates through the provided list of numbers row by row, compares each pair of consecutive numbers, and counts those where the previous is smaller than the next.

To try it out, load the file Day01.hs in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 7.
* The expected output for *input2.txt* is 1722. 

## Part 2
The function **windowChecker** works exactly like **rowChecker**, but instead iterates through the list of numbers comparing the sum of the first three numbers to the sum of the second, third ,and fourth, and continues as if sliding a window, covering 3 numbers at once. It counts every time the previous sum is smaller than the next.

To try it out, load the file Day01.hs in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 5.
* The expected output for *input2.txt* is 1748. 
