# Day 12
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/12)

## Part 1

* **allPathsDFS** takes a graph in the form of an adjacency list. Starts with a stack, containing only the "start" node. On each step it takes the neighbours of the current node in the stack's top which are either uppercase or not in the stack (not visited yet). Afterwards, it calls the function for each different neighbour, putting it on top of the stack and counts all paths that eventually lead to the "end" node.

To try out the solution to **part 1**, load the file *Day12.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 10.
* The expected output for *input2.txt* is 19.
* The expected output for *input3.txt* is 226.
* The expected output for *input4.txt* is 4411.

> One possible optimization is to use a map instead of a stack, keep the last visited node in a separate variable, and to store the graph in a map as well.

## Part 2

* **allPathsOneRepetitionDFS** does the same as **allPathsDFS**, but additionally tries to add a visited lowercase node to the stack if there hasn't already been one visited twice.

To try out the solution to **part 2**, load the file *Day12.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 36.
* The expected output for *input2.txt* is 103.
* The expected output for *input3.txt* is 3509.
* The expected output for *input4.txt* is 136767.
> Input 4 could take 10-15 seconds to compute for this part
 
> One possible optimization is to use a map instead of a stack and to store the graph in a map as well.
