# Day 13
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/13)

## Part 1

The "dots" are stored in a list for an easier approach to "folding". This does, however, increase the problem's time complexity. Each folding instruction is executed by **followInstructions**. It takes a list of rows and unites the first and last rows, then the second and second-to-last, etc if an instruction is for folding along *y* (always discarding the last remaining row in the middle). Otherwise it transposes the list, applies the  fold *as if it were along **y*** and transposes it back.

> Part 1 calls **followInstructions** with only the first instruction.

To try out the solution to **part 1**, load the file *Day13.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 17.
* The expected output for *input2.txt* is 671.
> Input 2 could take a few seconds.

## Part 2

> Part 2 calls **followInstructions** with a list of all the available instructions.

To try out the solution to **part 2**, load the file *Day13.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is **O**.
* The expected output for *input2.txt* is **PCPHARKL**.
> Input 2 could take a few seconds.
