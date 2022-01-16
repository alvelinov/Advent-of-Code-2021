# Day 20
>Descriptions of both problems can be found [here.](https://adventofcode.com/2021/day/20)

*It's all fun and games until 0 returns a lit pixel.*

Initially, the input image is enlarged twice, so that there are two layers of unlit pixels on each side. The enhancement algorithm goes like this:
1. Cut the outermost layer of the picture
2. Enlarge it twice with pixels, corresponding to the infinity part.
3. Apply the enhancement with the help of the provided array of pixel area encodings.
4. Repeat until the desired number of enhancements is reached

## Part 1

For this part, we need to enhance the picture twice.

To try out the solution to **part 1**, load the file *Day20.hs* in GHCI, call the function *main1*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 35.
* The expected output for *input2.txt* is 4873.

## Part 2

For this part, we need to enhance the picture 50 times.

To try out the solution to **part 2**, load the file *Day20.hs* in GHCI, call the function *main2*, and type in the name of the input file of your choosing (file extension included). 
* The expected output for *input1.txt* is 3351.
* The expected output for *input2.txt* is 16394.

> Input 2 takes 15-20 minutes to compute

> A possible optimization is to store the image in an array, instead of a list, and to remake it for each expansion/cut
