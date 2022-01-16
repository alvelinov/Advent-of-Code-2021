splitBy :: Char -> String -> [Int]
splitBy delim str = helper delim str ""
    where helper delim str acc
            | null str                      = [read (reverse acc)::Int]
            | head str == delim && null acc = helper delim (tail str) ""
            | head str == delim             = (read (reverse acc)::Int) : helper delim (tail str) ""
            | otherwise                     = helper delim (tail str) (head str : acc)

sumPositive :: [[Int]] -> Int
sumPositive matrix
    | null matrix            = 0
    | null (head matrix)     = sumPositive (tail matrix)
    | head (head matrix) > 0 = head (head matrix) + sumPositive (tail (head matrix) : (tail matrix))
    | otherwise              = sumPositive (tail (head matrix) : (tail matrix))

checkRows :: [[Int]] -> Bool
checkRows matrix
    | null matrix             = False
    | sum (head matrix) == -5 = True
    | otherwise               = checkRows (tail matrix)

checkCols :: [[Int]] -> Bool
checkCols matrix
    | null (head matrix)          = False
    | sum (map head matrix) == -5 = True
    | otherwise                   = checkCols (map tail matrix)

checkBingo :: [[Int]] -> Bool
checkBingo matrix = checkRows matrix || checkCols matrix

playRound :: [[Int]] -> Int -> [[Int]]
playRound matrix num = map (\row -> map (\x -> if x==num then -1 else x) row) matrix

checkForWinner :: [[[Int]]] -> Int
checkForWinner [] = -1
checkForWinner (matrix:matrixes)
    | checkBingo matrix = sumPositive matrix
    | otherwise         = checkForWinner matrixes

playBingo :: [[[Int]]] -> [Int] -> Int
playBingo matrixes bingoBalls = do
    let currBall    = (head bingoBalls)
    let newMatrixes = (map (\m -> playRound m currBall) matrixes)
    let win         = checkForWinner newMatrixes
    if win < 0
    then playBingo newMatrixes (tail bingoBalls)
    else currBall * win

parseBingoBoards :: [String] -> [[[Int]]]
parseBingoBoards strings = helper strings [[]]
    where helper [] matrixes = matrixes
          helper (s:strings) matrixes 
            | null s    = helper strings ([]:matrixes)
            | otherwise = helper strings (((splitBy ' ' s) : head matrixes) : (tail matrixes))
                                        
main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input       = lines contents
    let bingoBalls  = splitBy ',' (head input)
    let bingoBoards = parseBingoBoards (tail $ tail input)
    let result      = playBingo bingoBoards bingoBalls
    print result

-----------------------------------------------------------------------------------------

filterWinners :: [[[Int]]] -> [[[Int]]]
filterWinners [] = []
filterWinners (matrix:matrixes)
    | checkBingo matrix = filterWinners matrixes
    | otherwise         = matrix : filterWinners matrixes

playBingoToLose :: [[[Int]]] -> [Int] -> Int
playBingoToLose matrixes bingoBalls = do
    let currBall    = (head bingoBalls)
    let newMatrixes = (map (\m -> playRound m currBall) matrixes)
    if null (tail newMatrixes) && checkBingo (head newMatrixes)
        then sumPositive (head newMatrixes) * currBall
        else playBingoToLose (filterWinners newMatrixes) (tail bingoBalls)

main2 :: IO ()
main2 = do 
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input       = lines contents
    let bingoBalls  = splitBy ',' (head input)
    let bingoBoards = parseBingoBoards (tail $ tail input)
    let result      = playBingoToLose bingoBoards bingoBalls
    print result