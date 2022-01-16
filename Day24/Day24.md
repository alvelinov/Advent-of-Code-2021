# Day 24
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/24)

Hands down, one of my favourite problems from 2021's Advent of Code!

>The problem lies not within its explanation, but within the input itself. It codes a stack machine, which validates 14-digit numbers, based on some relations between pairs of digits in specific positions. A better explanation than I could possibly ever give is provided by [this big-brained fellow here.](https://github.com/kemmel-dev/AdventOfCode2021/blob/master/day24/AoC%20Day%2024.pdf)

Once the real problem is found, the path to solving both parts of this day's puzzle instantly becomes child's play.

> ALU included if you'd like to test some of the small examples given in the explanation using **runMONAD**, which takes the initial state of the ALU's variables (w,x,y,z), a list of triples of strings **(operation, left operand *(among w,x,y,z)*, right operand *(w,x,y,z, or a whole number)* )**, and a list of whole numbers from which the instruction *"inp"* can read.

## Part 1

In this part, we maximize the model number accepted by MONAD (MOdel Number Automatic Detector).

To try out the solution to **part 1**, load the file *Day24.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input2.txt* is 39999698799429.

## Part 2

In this part, we minimize the model number accepted by MONAD (MOdel Number Automatic Detector).

To try out the solution to **part 2**, load the file *Day24.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input2.txt* is 18116121134117.
