
# Day 10
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/10)

## Part 1
A simple solution which uses a stack and adds/pops brackets in it until we try to add a closing bracket and the stack's top isn't the same type of opening bracket.

To try out the solution to **part 1**, load the file *Day10.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 26397.
* The expected output for *input2.txt* is 318099.

## Part 2

First, for each line and with the help of **getLineComplement**,  from left to right, we can push opening and pop their complementary closing brackets. If a corruption occurs, the line complement is set to an empty list **[]**. Otherwise, it consists of the closing brackets left to be added. Next, each complement's score is calculated and scores equal to **0** are discarded (the corrupted line complements). The resulting list of scores is then sorted and its median is the desired result.

To try out the solution to **part 2**, load the file *Day10.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 288957.
* The expected output for *input2.txt* is 2389738699.
