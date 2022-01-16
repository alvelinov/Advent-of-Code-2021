# Day 2
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/2)

## Part 1
* **parse1** converts an instruction from the input into a pair of numbers that represents a move along the *x* and *y* axes.

To try out the solution to **part 1**, load the file *Day02.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 150.
* The expected output for *input2.txt* is 1893605.

## Part 2
* **parse2** converts an instruction from the input into a triple of numbers *and*  takes into account the previous instruction that represents a move along the *x* and *y* axes **and** tracks the ship's aim, the latter of which directly affects the current instruction.

To try out the solution to **part 2**, load the file *Day02.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 900.
* The expected output for *input2.txt* is 2120734350.

