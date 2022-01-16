# Day 4
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/4)

## Part 1
* **splitBy** takes a comma-separated string of numbers and returns a list of those numbers.

* **parseBingoBoards** takes a list of number strings and returns the 5x5 bingo boards, contained in it (separated by empty lines).

* **playRound** takes a bingo board and a number and marks the number with **-1** if it's found on the board.

* **checkBingo** takes a matrix and searches for a full row or column of **-1**'s.

* **checkForWinner** takes a list of matrixes and returns the sum of all unmarked numbers on the first winning board found (if any).

* **playBingo** takes a list of all bingo boards and a list of balls. Draws balls and fills boards until a winner appears and returns the product of the last drawn bingo ball's number and the sum of all unmarked numbers on the winning board.

To try out the solution to **part 1**, load the file *Day04.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 4512.
* The expected output for *input2.txt* is 72770.

## Part 2

* **filterWinners** takes a list of bingo boards and returns a list of those who haven't won the last round.

* **playBingoToLose** takes a list of bingo boards and a list of bingo balls. Returns the last winning board's sum of unmarked numbers multiplied by the last drawn ball.

To try out the solution to **part 2**, load the file *Day04.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 1924.
* The expected output for *input2.txt* is 13912.
