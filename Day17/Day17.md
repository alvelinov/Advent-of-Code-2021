# Day 17
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/17)

## Part 1

When you've studied mathematics, this part is a breeze. We always start at position (0,0) and our target is always **below** us. The probe slows down by 1 with each step going upwards and speeds up by 1 with each step going downwards. This means that the last step could be maximized with the max depth of the target area (the start of the interval for *y*). The sum of the rest of the steps toward the top is (**maxDepth-1** + **maxDepth-2** + ... + 2 + 1),  which can be also written as **((maxDepth-1) x maxDepth)/2**

To try out the solution to **part 1**, load the file *Day17.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 45.
* The expected output for *input2.txt* is 17766.

## Part 2

The **smallest x** that is enough to get to the target is the lower bound of *x*. The upper bound is the target's right bound. The **smallest y** is the lower bound of *y* and is also the lower bound of the target. The upper bound for *y* is the best *y* from part 1. These two intervals are merged via Cartesian product and each pair of the resulting set is tested for whether it hits the target area at some point during its trajectory, or completely misses it.

To try out the solution to **part 2**, load the file *Day17.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 112.
* The expected output for *input2.txt* is 1733.
