# Day 6
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/6)

## Part 1
* **splitBy** takes a comma-separated string of numbers and returns a list of those numbers.

* **fillPopulation** takes a list of single-digit numbers. Returns a list of numbers with 9 elements, containing the number of **0**'s in element 0, number of **1**'s in element one, etc all the way to 8.

* **expandPopulation** takes a list, returned by **fillPopulation**, cuts the first element, adds its contents to the new element 6, and finally appends them to the end of the new list, effectively simulating a population expansion.

* **passDays** takes a list, returned by **fillPopulation**, and a number of days/times it has to expand the population. Returns the final state of the population after all iterations.

To try out the solution to **part 1**, load the file *Day06.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 5934.
* The expected output for *input2.txt* is 350605.

## Part 2

To try out the solution to **part 2**, load the file *Day06.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 26984457539.
* The expected output for *input2.txt* is 1592778185024.
