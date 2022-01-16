import Data.Array

createAndFillArray :: (Ord a) => [a] -> Int -> Int -> Array (Int, Int) a
createAndFillArray input rowsNum colsNum = listArray ((0,0),(rowsNum-1, colsNum-1)) input

moveEast :: Array (Int, Int) Char -> Array (Int, Int) Char
moveEast arr = helper arr arr (assocs arr)
    where helper _ arr [] = arr
          helper inputArr changingArr (((i,j),v):pairs) = 
              let eastNeighbourKey   = if j == (snd $ snd $ bounds inputArr)
                                       then (i,(snd $ fst $ bounds inputArr))
                                       else (i,j+1)
                  eastNeighbourValue = (!) inputArr eastNeighbourKey
                in if v == '>' && eastNeighbourValue == '.'
                   then helper inputArr (changingArr//[((i,j),'.'), (eastNeighbourKey,'>')]) pairs
                   else helper inputArr changingArr pairs
                
moveSouth :: Array (Int, Int) Char -> Array (Int, Int) Char
moveSouth arr = helper arr arr (assocs arr)
    where helper _ arr [] = arr
          helper inputArr changingArr (((i,j),v):pairs) =
              let southNeighbourKey   = if i == (fst $ snd $ bounds inputArr)
                                        then   ((fst $ fst $ bounds inputArr),j)
                                        else   (i+1,j)
                  southNeighbourValue = (!) inputArr southNeighbourKey
                in if v == 'v' && southNeighbourValue == '.'
                   then helper inputArr (changingArr//[((i,j),'.'), (southNeighbourKey,'v')]) pairs
                   else helper inputArr changingArr pairs
          
stepsUntilHalt :: Array (Int, Int) Char -> Int
stepsUntilHalt arr = helper arr (assocs arr) 0
    where helper arr assocList stepsPassed = do
            let movedEast  = moveEast arr
                movedSouth = moveSouth movedEast
                in if assocList == (assocs movedSouth)
                   then stepsPassed+1
                   else helper movedSouth (assocs movedSouth) (stepsPassed+1)

-- For fun
{-
printCucumbers :: Int -> String -> IO ()
printCucumbers colsNum cucumbers = 
    if null cucumbers
    then
        print 0
    else do
        print $ take colsNum cucumbers
        printCucumbers colsNum (drop colsNum cucumbers)
-}

-- There is only one problem on day 25
-- Input 2 took 6 minutes to compute
main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let rawInput    = lines contents
    let colsNum     = length $ (head rawInput)
    let rowsNum     = length $ map head rawInput
    let input       = foldr (++) [] rawInput
    let parsedArray = createAndFillArray input rowsNum colsNum
    let result      = stepsUntilHalt parsedArray
    print result
