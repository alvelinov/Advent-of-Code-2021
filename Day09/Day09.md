# Day 9
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/9)

## Part 1
Initially, all numbers are saved in a list of pairs (number, mark). Going row by row, all numbers with a neighbour larger or equal to them get unmarked. Next, the same is done for all columns. Finally all remaining marked numbers are successed and added up.

> A faster solution would be to use an array instead, because that way we pass through each number exactly once. 

To try out the solution to **part 1**, load the file *Day09.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 15.
* The expected output for *input2.txt* is 558.

## Part 2

Initially, all numbers are marked with zeros. Since **each basin is enclosed by 9's**, they get marked with -1's.  Next comes a simple flood fill algorithm, which marks the first basin with 1's, the second with 2's and so on until there's nothing left to fill. Finally, a histogram is made from the markings **excluding -1** and the three most common numbers occurrences product gets returned.

To try out the solution to **part 2**, load the file *Day09.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 1134.
* The expected output for *input2.txt* is 882942.
