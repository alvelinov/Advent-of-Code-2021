import Data.Array

createAndFillArray :: (Ord a) => [a] -> Int -> Int -> Array (Int, Int) a
createAndFillArray input rowsNum colsNum = listArray ((0,0),(rowsNum-1, colsNum-1)) input

enlargeInitially :: [String] -> [String]
enlargeInitially image = let rowLength = length $ head image
                             newPixel  = '.'
                             newRow    = (take (rowLength + 2) (repeat newPixel))
                         in newRow : ((map (\row -> [newPixel]++row++[newPixel]) image) ++ [newRow])

cut :: [String] -> [String]
cut image = map init (map tail (tail $ init image))

enlarge :: [String] -> [String]
enlarge image = let rowLength = length $ head image
                    newPixel  = head $ head image
                    newRow    = (take (rowLength + 2) (repeat newPixel))
                in newRow : ((map (\row -> [newPixel]++row++[newPixel]) image) ++ [newRow])

printImage :: [String] -> IO ()
printImage img =
    if null $ tail img
    then print $ head img
    else do
        print $ head img
        printImage $ tail img

neighbours :: Int -> Int -> Array (Int, Int) a -> [a]
neighbours i j arr = [(!) arr (i-1,j-1), (!) arr (i-1,j), (!) arr (i-1,j+1),
                      (!) arr (i  ,j-1), (!) arr (i  ,j), (!) arr (i,  j+1),
                      (!) arr (i+1,j-1), (!) arr (i+1,j), (!) arr (i+1,j+1)]

binToInt :: [Int] -> Int
binToInt str = helper (reverse str) 1 0
    where helper [] _ acc = acc
          helper (digit:binNum) powOf2 acc = helper binNum (powOf2 * 2) (acc + powOf2*digit)

decode :: String -> Array Int Char -> Char
decode str algorithm = (!) algorithm (binToInt (map (\ch -> if ch == '#' then 1 else 0) str))

enhanceImage :: [String] -> Array Int Char -> [String]
enhanceImage image algorithm = 
    let largerIMG = createAndFillArray (foldr (++) [] image) (length $ map head image) (length $ head image)
    in helper largerIMG algorithm largerIMG (assocs largerIMG)
    where helper _          _         enhancedIMG [] = chunksOf ((snd $ snd $ bounds enhancedIMG) + 1) (map snd (assocs enhancedIMG))
          helper initialIMG algorithm enhancedIMG (((i,j),pixel):pixels)
            | i == 0 || i == (fst $ snd $ bounds initialIMG) || j == 0 || j == (snd $ snd $ bounds initialIMG) = 
                    helper initialIMG algorithm enhancedIMG pixels
            | otherwise = 
                    helper initialIMG algorithm (enhancedIMG//[((i,j), decode (neighbours i j initialIMG) algorithm)]) pixels

enhanceXtimes :: [String] -> Array Int Char -> Int -> [String]
enhanceXtimes image _ 0 = cut image
enhanceXtimes image ehnancementAlgorithm timesLeft = 
        enhanceXtimes (enhanceImage (enlarge $ enlarge $ cut image) ehnancementAlgorithm) ehnancementAlgorithm (timesLeft-1)

chunksOf :: Int -> [a] -> [[a]]
chunksOf num [] = []
chunksOf num xs = (take num xs) : chunksOf num (drop num xs)

countLitPixels :: String -> Int
countLitPixels str = sum $ (map (\ch -> if ch=='#' then 1 else 0) str)

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let rawInput             = lines contents
    let ehnancementAlgorithm = listArray (0, 511) (head rawInput)
    let image                = drop 2 rawInput
    let largerIMG            = enlarge $ enlargeInitially image
    let res                  = sum $ (map countLitPixels (enhanceXtimes largerIMG ehnancementAlgorithm 2))
    print res

------------------------------------------------------------------------------------------------------------------------

-- Terminates in 15 minutes for input2.txt
main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let rawInput             = lines contents
    let ehnancementAlgorithm = listArray (0, 511) (head rawInput)
    let image                = drop 2 rawInput
    let largerIMG            = enlarge $ enlargeInitially image
    let res                  = sum $ (map countLitPixels (enhanceXtimes largerIMG ehnancementAlgorithm 50))
    print res