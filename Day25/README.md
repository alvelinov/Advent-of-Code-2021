# Day 25
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/25)

> This problem has only one part

## Part 1

The function **stepsUntilHalt** takes an array of sea cucumbers and:
1. moves the east-facing ones, taking into account the positions of all cucumbers from the beginning of this step.
2. Moves the south-facing ones, considering the positions of all cucumbers the moment after the east-facing herd has moved.
3. Continues from the top with the newly aligned herd.

To try out the solution to **part 1**, load the file *Day25.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 58.
* The expected output for *input2.txt* is 308.

> Input 2 takes 4-8 minutes to compute
