isDigitOrDash :: Char -> Bool
isDigitOrDash ch = ch=='-' || ch>='0' && ch <='9'

getNumbers :: [Char] -> [String]
getNumbers [] = []
getNumbers str = 
    let start = dropWhile (\c -> not $ isDigitOrDash c) str
        num   = takeWhile (\c -> isDigitOrDash c) start
        rest  = dropWhile (\c -> isDigitOrDash c) start
    in num : getNumbers rest

bestY :: Int -> Int -> Int
bestY startY endY = abs(startY) - 1

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input  = map (\str -> (read str)::Int) (getNumbers $ head $ lines contents)
    let startY = last $ init input
    let endY   = last input
    let result = let best = bestY startY endY in best*(best+1) `div` 2
    print result

-------------------------------------------------------------------------------------------------------

smallestX :: Int -> Int -> Int
smallestX startX endX = minimum [ x | x <- [1..endX], elem (x*(x+1) `div` 2) [startX .. endX] ]

possibleXs :: Int -> Int -> [Int]
possibleXs startX endX = [(smallestX startX endX) .. endX]

-- relies on the truthfulness of startY <= endY and both of them being negative
possibleYs :: Int -> Int -> [Int]
possibleYs startY endY = [startY .. bestY startY endY]

increaceX :: Int -> Int
increaceX 0 = 0
increaceX x = x-1

increaceY :: Int -> Int
increaceY y = y-1

hitOrMiss :: (Int, Int) -> Int -> Int -> Int -> Int -> Bool
hitOrMiss (x,y) startX endX startY endY = helper (0,0) x y
    where helper (accX, accY) incX incY
            | accX >= startX && accX <= endX && accY >= startY && accY <= endY   = True
            | accY <  startY || accX >  endX                                     = False
            | otherwise = helper (accX + incX, accY + incY) (increaceX incX) (increaceY incY)

usefulPairs :: [(Int, Int)] -> Int -> Int -> Int -> Int -> [(Int, Int)]
usefulPairs [] _ _ _ _ = []
usefulPairs ((x,y):pairs) startX endX startY endY = 
    if hitOrMiss (x,y) startX endX startY endY
    then (x,y) : usefulPairs pairs startX endX startY endY
    else usefulPairs pairs startX endX startY endY

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input      = map (\str -> (read str)::Int) (getNumbers $ head $ lines contents)
    let startX     = head input
    let endX       = head $ tail input
    let startY     = last $ init input
    let endY       = last input
    let pairsToTry = [(x,y) | x <- possibleXs startX endX, y <- possibleYs startY endY]
    let result     = length $ usefulPairs pairsToTry startX endX startY endY
    print result
