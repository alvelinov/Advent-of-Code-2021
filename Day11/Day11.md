# Day 11
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/11)

The best possible solution I could come up with was to put everything in an Array.

## Part 1

* **flash** spreads all flashes that occur in one step.
* **flashesAfterXsteps** takes a population of octopuses (2D array of numbers) and a number of steps in which to charge and flash octopuses. Counts the flashes after each step and sums them up.

To try out the solution to **part 1**, load the file *Day11.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 1656.
* The expected output for *input2.txt* is 1632.

## Part 2

* **stepOfSync** iterates steps and spreads flashes until all octopuses flash in a single step. Returns that exact step's number.

To try out the solution to **part 2**, load the file *Day11.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 195.
* The expected output for *input2.txt* is 303.
