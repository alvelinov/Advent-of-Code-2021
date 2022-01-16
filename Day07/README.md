# Day 7
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/7)

## Part 1
* **splitBy** takes a comma-separated string of numbers and returns a list of those numbers.

* **cumulativeDistances** takes the list of all crabs' positions, the first position, and the last position, and returns a list of the costs of all possible positions in which the crabs can align.

To try out the solution to **part 1**, load the file *Day07.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 37.
* The expected output for *input2.txt* is 348996.

## Part 2
* **cumulativeDistances2** takes the list of all crabs' positions, the first position, and the last position, and returns a list of the costs of all possible positions in which the crabs can align, accounting for the cost of travel with crab technology. :)

> **part 2** could take a few seconds to calculate input 2

To try out the solution to **part 2**, load the file *Day07.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 168.
* The expected output for *input2.txt* is 98231647.
