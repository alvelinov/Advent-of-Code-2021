import Data.Char (digitToInt)
import Data.Array
import Data.List (sortOn)

transpose :: [[a]] -> [[a]]
transpose matrix@(h:_) = if null h then [] else map head matrix : (transpose $ map tail matrix)

markByRow :: [[(Int, Bool)]] -> [[(Int, Bool)]]
markByRow matrix = helper matrix
    where rowChecker _    []                  = []
          rowChecker _    ((i, False) : rest) = (i, False) : rowChecker i rest
          rowChecker last ((i,True)   : rest)
            | null rest                         = if i<last then [(i,True)] else [(i, False)]
            | i>=last || i >= (fst $ head rest) = (i, False) : rowChecker i rest
            | otherwise                         = (i, True)  : rowChecker i rest
          helper []           = []
          helper (row:matrix) = rowChecker 10 row : helper matrix

sumSuccessorsOfMarked :: [[(Int, Bool)]] -> Int
sumSuccessorsOfMarked [] = 0
sumSuccessorsOfMarked ([]:matrix) = sumSuccessorsOfMarked matrix
sumSuccessorsOfMarked (row:matrix) = 
    if (snd $ head row) == True
    then (fst $ head row) + 1 + sumSuccessorsOfMarked ((tail row):matrix)
    else sumSuccessorsOfMarked ((tail row):matrix)

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input      = map (\str -> zip (map digitToInt str) (repeat True)) (lines contents)
    let finalState = markByRow $ transpose $ markByRow input
    let result     = sumSuccessorsOfMarked finalState
    print result

----------------------------------------------------------------------------------------------------------------

createAndFillArray :: (Ord a) => [a] -> Int -> Int -> Array (Int, Int) a
createAndFillArray input rowsNum colsNum = listArray ((0,0),(rowsNum-1, colsNum-1)) input

floodFill :: Array (Int, Int) Int -> [((Int, Int), Int)] -> Int -> Array (Int, Int) Int
floodFill matrix [] _ = matrix
floodFill matrix (((i,j), val):pairs) num
    | val < 0 || val == num = matrix
    | otherwise = let floodedLeft  = floodFill (matrix//[((i,j), num)]) [leftNeighbour i j matrix] num
                      floodedRight = floodFill floodedLeft  [rightNeighbour i j floodedLeft]  num
                      floodedUp    = floodFill floodedRight [upperNeighbour i j floodedRight] num
                      in             floodFill floodedUp    [lowerNeighbour i j floodedUp]    num
    where rightBound = snd $ snd $ bounds matrix
          bottomBound = fst $ snd $ bounds matrix
          dummy = ((0,0), (-1))
          leftNeighbour  i j mat = if j==0 then dummy else ((i,j-1), (!) mat (i, j-1))
          rightNeighbour i j mat = if j==rightBound then dummy else ((i,j+1), (!) mat (i, j+1))
          upperNeighbour i j mat = if i==0 then dummy else ((i-1,j), (!) mat (i-1, j))
          lowerNeighbour i j mat = if i==bottomBound then dummy else ((i+1,j), (!) mat (i+1, j))

multiFloodFill :: Array (Int, Int) Int -> Array (Int, Int) Int
multiFloodFill matrix = helper matrix (filter (\(k,v) -> if v==0 then True else False) (assocs matrix)) 1
    where helper matrix [] _ = matrix
          helper matrix pairs num = let nextFill   = floodFill matrix pairs num
                                        nextToFill = (filter (\(k,v) -> if v==0 then True else False) (assocs nextFill))
                                    in if not $ null $ nextToFill 
                                       then helper nextFill nextToFill (num+1)
                                       else nextFill

-- To see the big picture better
printGrid :: [[Int]] -> IO ()
printGrid grid =
    if null $ tail grid
    then print $ head grid
    else do
        print $ head grid
        printGrid $ tail grid

occurences :: (Eq a) => a -> [a] -> Int
occurences _ [] = 0
occurences ch (c:str)
    | c == ch   = 1 + occurences ch str
    | otherwise = occurences ch str

removeAll :: (Eq a) => a -> [a] -> [a]
removeAll _ [] = []
removeAll ch (c:str)
    | c == ch   = removeAll ch str
    | otherwise = c : removeAll ch str

histogram :: (Eq a) =>  [a] -> [(a, Int)]
histogram [] = []
histogram (ch:str) = (ch, 1 + occurences ch str) : histogram (removeAll ch str)

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents <- readFile inputFileName
    let rawInput     = map (\str -> map (\(k,v) -> if k==9 then (k, (-1)) else (k,v)) (zip (map digitToInt str) (repeat 0))) (lines contents)
    let rowSize      = length $ head rawInput
    let colSize      = length $ map head rawInput
    let input        = createAndFillArray (map snd (foldr (++) [] rawInput)) colSize rowSize
    let resultMatrix = multiFloodFill input
    let result       = product $ map snd (take 3 (reverse $ sortOn snd [ (k,v) | (k,v) <- histogram (map snd (assocs resultMatrix)), k /= -1]))
    print result

