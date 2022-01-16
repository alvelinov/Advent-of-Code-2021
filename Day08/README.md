# Day 8
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/8)

## Part 1
The problem's description is straightforward enough to understand how this part works.

To try out the solution to **part 1**, load the file *Day08.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 26.
* The expected output for *input2.txt* is 409.

## Part 2

In my approach, on each line I first make a histogram of all letters in the coded part (first 10 codes). Then I follow these steps:
1. *Segments 2, 5, and 6* have unique numbers of occurrences (6, 4, and 9 respectively), so they get decoded first. 

2.  Afterwards I decode *segment 3* by taking the code of the digit 1 (always with length 2) and seeing which of its segments hasn't been decoded yet (the one that has been decoded is *segment 6* from the previous step).
3. Next, with the help of the histogram, I decode *segment 1* by taking the two segments with 8 occurrences across the coded part (*segment 1* and *segment 3*). A simple check which one of them has already been decoded gives us the other for free. Since *segment 3* is decoded in the previous step, we get our code for *segment 1*.

4. With the help of the encoded number 4 (with a unique length of 4 segments - 2, 3, 4, and 6) and the decoded segments so far, we can decode another segment. The only non-decoded segment of the number 4 is *segment 4*. 

5. Finally, among the characters in "abcdef" only one remains to be decoded. A simple run through the list of decoded characters gives us the one which encodes *segment 7*

6. After all the decoding of segments, we can now decode the outputs of all input lines and sum them up.

To try out the solution to **part 2**, load the file *Day08.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 61229.
* The expected output for *input2.txt* is 1024649.
