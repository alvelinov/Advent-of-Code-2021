# Day 5
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/5)

This is quite the dumpster fire of an implementation. Every interval is stored as a list of 4 numbers, the grid is stored in a list as well. Filling the grid is slow.

> Possible optimizations:
> 1. Store the grid in an array.
> 2. Store the intervals in 4-element tuples.

## Part 1

To try out the solution to **part 1**, load the file *Day05.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 5.
* The expected output for *input2.txt* is 5576.

> Input 2 takes one minute to compute.

## Part 2

To try out the solution to **part 2**, load the file *Day05.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 12.
* The expected output for *input2.txt* is 18144.

> Input 2 takes 5-10 minutes to compute.
