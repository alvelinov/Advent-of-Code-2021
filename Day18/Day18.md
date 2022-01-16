# Day 18
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/18)

## Part 1

With the help of **addUpSnailNumberWithList**, we take the first number and a list of the rest. On each step the first number and the first one from the list are added up, the result is reduced, and the process repeats until the list empties. The final result gets its magnitude calculated.

To try out the solution to **part 1**, load the file *Day18.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 4140.
* The expected output for *input2.txt* is 3816.

## Part 2

Each pair of different numbers gets its reduced sum's magnitude calculated. The maximum element from the resulting list of magnitudes is the answer to our puzzle.

To try out the solution to **part 2**, load the file *Day18.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 3993.
* The expected output for *input2.txt* is 4819.
> Input 2 takes around 1 minute to compute
