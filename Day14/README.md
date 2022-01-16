# Day 14
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/14)

## Part 1

In this part, I implemented the naive approach - inserting letters between each pair 10 times, making a histogram of the result, and subtracting the quantity of the least common element from that of the most common  element.

To try out the solution to **part 1**, load the file *Day14.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 1588.
* The expected output for *input2.txt* is 3408.

## Part 2

This is where it gets interesting. For 40 steps, the previous approach might never produce a result, because of its immense load on memory. Instead, we can see that the parts on the left of each input line are all the pairs that can ever show up. Why don't we just put them in a tracking list and update it instead? On each step a new list is created and then updated, using the values from the previously created one. We make a pair into two pairs (via the provided list of insertions) and add its count to both of the new pairs' counts. In the end we "split" the pairs into single letters and sum up the occurrences of each letter. Since the same letter shows up in **two** pairs, we need to divide the counts by 2. The first (and the last) letter is always part of **one** pair, but whole number division during the counting phase saves us the trouble of tracking this in a separate case.

To try out the solution to **part 2**, load the file *Day14.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 2188189693529.
* The expected output for *input2.txt* is 3724343376942.
