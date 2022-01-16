import Data.List (sort)

splitBy :: Char -> String -> [Int]
splitBy delim str = splitBy delim str ""
    where splitBy delim str acc
            |null str = [read (reverse acc)::Int]
            |head str == delim && null acc = splitBy delim (tail str) ""
            |head str == delim = (read (reverse acc)::Int) : splitBy delim (tail str) ""
            |otherwise = splitBy delim (tail str) (head str : acc)

transpose :: [[a]] -> [[a]]
transpose matrix@(h:_) = if null h then [] else map head matrix : (transpose $ map tail matrix)

mergeRows :: String -> String -> String
mergeRows [] _ = []
mergeRows (x:xs) (y:ys)
    | x == '#' || y == '#' = '#' : mergeRows xs ys
    | otherwise            = '.' : mergeRows xs ys

foldSheet :: [String] -> Char -> Int -> [String]
foldSheet sheet direction indent
    | direction == 'y' = zipWith mergeRows (take indent sheet) (reverse $ drop (indent+1) sheet)
    | otherwise        = transpose $ zipWith mergeRows (take indent transposedSheet) (reverse $ drop (indent+1) transposedSheet)
    where transposedSheet = transpose sheet

followInstructions :: [String] -> [(Char, Int)] -> [String]
followInstructions sheet [] = sheet
followInstructions sheet ((c, i):instructions) = followInstructions (foldSheet sheet c i) instructions

printSheet :: [String] -> IO ()
printSheet (row:sheet) = 
    if null sheet
    then
        print row
    else do
        print row
        printSheet sheet

placeHashtags :: [String] -> [(Int, Int)] -> [String]
placeHashtags sheet [] = sheet
placeHashtags sheet coordinates = helper sheet coordinates 0
    where helper sheet [] _ = sheet
          helper (row:sheet) c@((x,y):coordinates) rowCount
            | rowCount == x = (fillRow row (map snd (takeWhile (\(a,_) -> a==x) c)) 0) : helper sheet (dropWhile (\(a,_) -> a==x) c) (rowCount+1)
            | otherwise     = row : helper sheet c (rowCount + 1)
          fillRow row [] _ = row
          fillRow (ch:row) p@(pos:positions) colCount
            | colCount == pos = '#' : fillRow row positions (colCount+1)
            | otherwise       =  ch : fillRow row p (colCount+1)

countHashtags :: String -> Int
countHashtags [] = 0
countHashtags (char:string) =
    if char == '#'
    then 1 + countHashtags string
    else countHashtags string

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input           = lines contents
    let leftAndRight    = transpose $ map (\str -> splitBy ',' str) (takeWhile (/=[]) input)
    let sheetInfo       = sort (map (\(x,y) -> (y,x)) (zip (head leftAndRight) (head $ tail leftAndRight)))
    let instructions    = map (\str -> (head str, read (drop 2 str)::Int)) (map (\str -> drop 11 str) (tail $ dropWhile (/=[]) input))
    let sheet           = take ((maximum $ head $ tail leftAndRight) + 1) (repeat $ take ((maximum $ head leftAndRight) + 1) (repeat '.'))
    let filledSheet     = placeHashtags sheet sheetInfo
    let onceFoldedSheet = followInstructions filledSheet [head instructions]
    let result          = sum $ map countHashtags onceFoldedSheet
    print result

----------------------------------------------------------------------------------------------

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input        = lines contents
    let leftAndRight = transpose $ map (\str -> splitBy ',' str) (takeWhile (/=[]) input)
    let sheetInfo    = sort (map (\(x,y) -> (y,x)) (zip (head leftAndRight) (head $ tail leftAndRight)))
    let instructions = map (\str -> (head str, read (drop 2 str)::Int)) (map (\str -> drop 11 str) (tail $ dropWhile (/=[]) input))
    let sheet        = take ((maximum $ head $ tail leftAndRight) + 1) (repeat $ take ((maximum $ head leftAndRight) + 1) (repeat '.'))
    let filledSheet  = placeHashtags sheet sheetInfo
    let foldedSheet  = followInstructions filledSheet instructions
    printSheet foldedSheet