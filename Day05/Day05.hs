import Text.Read

isDigit :: Char -> Bool
isDigit ch
    | ch >= '0' && ch <= '9' = True
    | otherwise              = False

getNumbers :: String -> [Int]
getNumbers str = getNumbers str ""
    where getNumbers str acc
            | null str                              = [read (reverse acc)::Int]
            | not (isDigit (head str))  && null acc = getNumbers (tail str) ""
            | not (isDigit (head str))              = (read (reverse acc)::Int) : getNumbers (tail str) ""
            | otherwise                             = getNumbers (tail str) (head str : acc)

-- makes a NxN grid of zeros
createGrid :: Int -> [[Int]]
createGrid size = createGrid size 0
    where createGrid size cnt
            | cnt > size = []
            | otherwise  = take size (repeat 0) : createGrid size (cnt + 1)

first :: [Int] -> Int
first arr = (head arr)

second :: [Int] -> Int
second arr = head (tail arr)

third :: [Int] -> Int
third arr = head (tail (tail arr))

normalizeRowsAndCols :: [Int] -> [Int]
normalizeRowsAndCols arr
    | second arr == last arr && third arr < first arr = normalizeRowsAndCols [third arr, second arr, first arr, last arr]
    | first arr == third arr && last arr < second arr = normalizeRowsAndCols [first arr, last arr, third arr, second arr]
    | otherwise = arr

succElement :: Int -> [Int] -> [Int]
succElement el arr
    |el == 0   = (head arr + 1) : (tail arr)
    |otherwise = head arr : succElement (el - 1) (tail arr)

fillColumn :: [[Int]] -> Int -> Int -> Int -> [[Int]]
fillColumn grid colNum startRow endRow = fillColumn grid 0
    where fillColumn grid rowCount
            | rowCount < startRow                        = (head grid) : fillColumn (tail grid) (rowCount + 1)
            | rowCount >= startRow && rowCount <= endRow = (succElement colNum (head grid)) : fillColumn (tail grid) (rowCount + 1)
            | otherwise                                  = grid

succFromTo :: [Int] -> Int -> Int -> [Int]
succFromTo arr start end = succFromTo arr 0
    where succFromTo arr count
            | count < start                  = (head arr) : succFromTo (tail arr) (count + 1)
            | count >= start && count <= end = (head arr + 1) : succFromTo (tail arr) (count + 1)
            | otherwise                      = arr

fillRow :: [[Int]] -> Int -> Int -> Int -> [[Int]]
fillRow grid rowNum startCol endCol
    | rowNum == 0 = (succFromTo (head grid) startCol endCol) : (tail grid)
    | otherwise   = (head grid) : fillRow (tail grid) (rowNum - 1) startCol endCol

fillData :: [[Int]] -> [Int] -> [[Int]]
fillData grid dataz
    | first dataz  == third dataz  = fillColumn grid (first dataz) (second dataz) (last dataz)
    | second dataz == (last dataz) = fillRow grid (second dataz) (first dataz) (third dataz)
    | otherwise                    = grid

getResult :: [[Int]] -> Int
getResult grid
    | null grid = 0
    | otherwise = sum (map (\el -> if el > 1 then 1 else 0) (head grid)) + getResult (tail grid)

followCommands1 :: [[Int]] -> [[Int]] -> [[Int]]
followCommands1 grid [] = grid
followCommands1 grid (c:commands) = followCommands1 (fillData grid c) commands

askForGridSize = do
    print "Please enter the size of your grid: "
    line <- getLine
    pure ((read line)::Int)

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let gridSize = 1 + (maximum $ foldr (++) [] $ map getNumbers (lines contents))
    let grid     = createGrid gridSize
    let commands = map normalizeRowsAndCols (map getNumbers (lines contents))
    let result   = getResult $ followCommands1 grid commands
    print result

-------------------------------------------------------------------------------------------------------------

fillDiagonal :: [[Int]] -> (Int->Int) -> Int -> Int -> Int -> Int -> [[Int]]
fillDiagonal grid colOp startCol startRow endCol endRow = fillDiagonal grid 0 startCol
    where fillDiagonal grid rowCount colCount
            | rowCount < startRow = (head grid) : fillDiagonal (tail grid) (rowCount + 1) colCount
            | rowCount > endRow   = grid
            | otherwise           = (succElement colCount (head grid)) : fillDiagonal (tail grid) (rowCount + 1) (colOp colCount)

fillData2 :: [[Int]] -> [Int] -> [[Int]]
fillData2 grid dataz
    | first dataz == third dataz   = fillColumn grid (first dataz) (second dataz) (last dataz)
    | second dataz == (last dataz) = fillRow grid (second dataz) (first dataz) (third dataz)
    | first dataz < third dataz    = fillDiagonal grid (+1) (first dataz) (second dataz) (third dataz) (last dataz)
    | first dataz > third dataz    = fillDiagonal grid (\x -> x-1) (first dataz) (second dataz) (third dataz) (last dataz)
    | otherwise                    = grid

normalizeData :: [Int] -> [Int]
normalizeData arr
    | second arr == last arr && third arr < first arr = normalizeData [third arr, second arr, first arr, last arr]
    | first arr == third arr && last arr < second arr = normalizeData [first arr, last arr, third arr, second arr]
    | second arr > last arr                           = normalizeData [third arr, last arr, first arr, second arr]
    | otherwise                                       = arr

followCommands2 :: [[Int]] -> [[Int]] -> [[Int]]
followCommands2 grid [] = grid
followCommands2 grid (c:commands) = followCommands2 (fillData2 grid c) commands

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let gridSize = 1 + (maximum $ foldr (++) [] $ map getNumbers (lines contents))
    let grid     = createGrid gridSize
    let commands = map normalizeData (map getNumbers (lines contents))
    let result   = getResult $ followCommands2 grid commands
    print result