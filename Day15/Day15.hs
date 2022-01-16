import Data.Char (digitToInt)
import Data.Array

createAndFillArray :: (Ord a) => [a] -> Int -> Int -> Array (Int, Int) a
createAndFillArray input rowsNum colsNum = listArray ((0,0),(rowsNum-1, colsNum-1)) input

getCostByKey :: (Int, Int) -> [((Int, Int), Int)] -> Int
getCostByKey _ [] = 0 -- There is no free lunch
getCostByKey key ((k,v):pairs)
    | key==k    = v
    | otherwise = getCostByKey key pairs

replaceValueIn :: (Int, Int) -> Int -> [((Int, Int), Int)] -> [((Int, Int), Int)]
replaceValueIn key value ((k,v):pairs)
    | key==k    = (key, value) : pairs
    | otherwise = (k,v) : replaceValueIn key value pairs

tryEnqueue :: ((Int, Int), Int) -> [((Int, Int), Int)] -> [((Int, Int), Int)]
tryEnqueue node [] = [node]
tryEnqueue (key, value) queue
        | cost>value = replaceValueIn key value queue
        | cost == 0  = insertInSorted (key, value) queue
        | otherwise  = queue
    where cost = getCostByKey key queue
          insertInSorted elem [] = [elem]
          insertInSorted elem@(_,v1) queue@((k,v2):pairs)
            | v1 <= v2   = elem : queue
            | otherwise = (k,v2) : insertInSorted elem pairs 

enqueueFromList :: [((Int, Int), Int)] -> [((Int, Int), Int)] -> [((Int, Int), Int)]
enqueueFromList [] queue = queue
enqueueFromList (x:xs) queue = enqueueFromList xs (tryEnqueue x queue)

neighbours :: (Int, Int) -> Int -> Int -> Array (Int, Int) Int -> [((Int, Int), Int)]
neighbours (i,j) maxRow maxCol arr
    | i==0      && j==0      = [((i,j+1),(!) arr (i,j+1)), ((i+1,j), (!) arr (i+1,j))]
    | i==0      && j==maxCol = [((i,j-1),(!) arr (i,j-1)), ((i+1,j), (!) arr (i+1,j))]
    | i==maxRow && j==0      = [((i,j+1),(!) arr (i,j+1)), ((i-1,j), (!) arr (i-1,j))]
    | i==maxRow && j==maxCol = [((i,j-1),(!) arr (i,j-1)), ((i-1,j), (!) arr (i-1,j))]
    | i==0                   = [((i,j-1),(!) arr (i,j-1)), ((i+1,j), (!) arr (i+1,j)), ((i,j+1), (!) arr (i,j+1))]
    | i==maxRow              = [((i,j-1),(!) arr (i,j-1)), ((i-1,j), (!) arr (i-1,j)), ((i,j+1), (!) arr (i,j+1))]
    |              j==0      = [((i-1,j),(!) arr (i-1,j)), ((i,j+1), (!) arr (i,j+1)), ((i+1,j), (!) arr (i+1,j))]
    |              j==maxCol = [((i-1,j),(!) arr (i-1,j)), ((i,j-1), (!) arr (i,j-1)), ((i+1,j), (!) arr (i+1,j))]
    |       otherwise        = [((i-1,j),(!) arr (i-1,j)), ((i,j-1), (!) arr (i,j-1)), ((i+1,j), (!) arr (i+1,j)), ((i,j+1), (!) arr (i,j+1))]

lowestTotalRisk :: Array (Int, Int) Bool -> Array (Int, Int) Int -> (Int, Int) -> [((Int, Int), Int)] -> Int
lowestTotalRisk visits riskLevels goal@(maxRow, maxCol) ((key,value):queue)
    | key==goal = value
    | otherwise = lowestTotalRisk (visits//[(key, True)]) riskLevels goal 
                    (enqueueFromList 
                        (map (\(k,v) -> (k,v+value)) 
                            [(k,v) | (k,v)<-(neighbours key maxRow maxCol riskLevels), (!) visits k == False])
                                queue)

{- For curiosity and debugging purposes
lowestTotalRiskWithPath :: [((Int, Int),Int)] -> Array (Int, Int) Bool -> Array (Int, Int) Int -> (Int, Int) -> [((Int, Int), Int)] -> (Int,[((Int, Int),Int)])
lowestTotalRiskWithPath p visits riskLevels goal@(maxRow, maxCol) ((key,value):queue)
    | key==goal = (value, reverse p)
    | otherwise = lowestTotalRiskWithPath ((key,value):p) (visits//[(key, True)]) riskLevels goal 
                    (enqueueFromList 
                        (map (\(k,v) -> (k,v+value)) 
                            [(k,v) | (k,v)<-(neighbours key maxRow maxCol riskLevels), (!) visits k == False])
                                queue)
-}

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let rawInput    = map (\str -> map digitToInt str) (lines contents)
    let rowsNum     = length $ head rawInput
    let colsNum     = length $ map head rawInput
    let input       = foldr (++) [] rawInput
    let parsedArray = createAndFillArray input rowsNum colsNum
    let visitsArray = createAndFillArray (repeat False) rowsNum colsNum
    let result      = lowestTotalRisk (visitsArray//[((0,0),True)]) parsedArray (rowsNum-1, colsNum-1) [((0,0),0)]
    print result

---------------------------------------------------------------------------------------------------------

specialSucc :: Int -> Int
specialSucc 9 = 1
specialSucc x = x+1

appendMatrixes :: [[a]] -> [[a]] -> [[a]]
appendMatrixes [] [] = []
appendMatrixes (row1:m1) (row2:m2) = (row1 ++ row2) : appendMatrixes m1 m2

extendRight :: [[Int]] -> [[Int]]
extendRight matrix = helper matrix (map (\arr -> map specialSucc arr) matrix) 4
    where helper accum _ 0 = accum
          helper accum matrix appendsleft = helper (appendMatrixes accum matrix) (map (\arr -> map specialSucc arr) matrix) (appendsleft-1)

extendDown :: [[Int]] -> [[Int]]
extendDown matrix = helper matrix 5
    where helper _ 0 = []
          helper matrix stepsLeft = matrix ++ helper (map (\arr -> map specialSucc arr) matrix) (stepsLeft-1)

extend :: [[Int]] -> [[Int]]
extend arr = extendDown $ extendRight arr 

-- Took 10 minutes and 5 seconds on my machine for input2.txt, but the answer was correct nonetheless
main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let rawInput      = map (\str -> map digitToInt str) (lines contents)
    let rowsNum       = length $ head rawInput
    let colsNum       = length $ map head rawInput
    let extendedInput = extend rawInput
    let input         = foldr (++) [] extendedInput
    let parsedArray   = createAndFillArray input (5*rowsNum) (5*colsNum)
    let visitsArray   = createAndFillArray (repeat False) (5*rowsNum) (5*colsNum)
    let result        = lowestTotalRisk (visitsArray//[((0,0),True)]) parsedArray (5*rowsNum-1, 5*colsNum-1) [((0,0),0)]
    print result
