import Data.Char (isDigit)
import Data.List (sort)

splitBy :: Char -> String -> [String]
splitBy delim str = splitBy delim str ""
    where splitBy delim str acc
            |null str = [reverse acc]
            |head str == delim && null acc = splitBy delim (tail str) ""
            |head str == delim = (reverse acc) : splitBy delim (tail str) ""
            |otherwise = splitBy delim (tail str) (head str : acc)

getW :: (Int, Int, Int, Int) -> Int
getW (w,_,_,_) = w
getX :: (Int, Int, Int, Int) -> Int
getX (_,x,_,_) = x
getY :: (Int, Int, Int, Int) -> Int
getY (_,_,y,_) = y
getZ :: (Int, Int, Int, Int) -> Int
getZ (_,_,_,z) = z

numToDigits :: Int -> [Int]
numToDigits 0 = [0]
numToDigits num = helper num []
    where helper 0 acc = acc
          helper num acc = helper (num `div` 10) (num `rem` 10 : acc)

calculate :: (Int, Int, Int, Int) -> String -> String -> (Int -> Int -> Int) -> (Int, Int, Int, Int)
calculate (w,x,y,z) operand1 operand2@(ch:t) op
    | ch == '-' || isDigit ch = case operand1 of
                                    "w" -> (op w (read operand2)::Int, x, y, z)
                                    "x" -> (w, op x (read operand2)::Int, y, z)
                                    "y" -> (w, x, op y (read operand2)::Int, z)
                                    "z" -> (w, x, y, op z (read operand2)::Int)
    | ch == 'w'               = case operand1 of
                                    "w" -> (op w w, x, y, z)
                                    "x" -> (w, op x w, y, z)
                                    "y" -> (w, x, op y w, z)
                                    "z" -> (w, x, y, op z w)
    | ch == 'x'               = case operand1 of
                                    "w" -> (op w x, x, y, z)
                                    "x" -> (w, op x x, y, z)
                                    "y" -> (w, x, op y x, z)
                                    "z" -> (w, x, y, op z x)
    | ch == 'y'               = case operand1 of
                                    "w" -> (op w y, x, y, z)
                                    "x" -> (w, op x y, y, z)
                                    "y" -> (w, x, op y y, z)
                                    "z" -> (w, x, y, op z y)
    | ch == 'z'               = case operand1 of
                                    "w" -> (op w z, x, y, z)
                                    "x" -> (w, op x z, y, z)
                                    "y" -> (w, x, op y z, z)
                                    "z" -> (w, x, y, op z z)

-- MOdel Number Automatic Detector program
runMONAD :: (Int, Int, Int, Int) -> [(String, String, String)] -> [Int] -> (Int, Int, Int, Int)
runMONAD alu [] _ = alu
runMONAD alu@(w,x,y,z) ((instr, aluVar, sec):instructions) inpNumbers =
    case instr of
        "inp" -> case aluVar of
                    "w" -> runMONAD (head inpNumbers, x     ,               y,               z) instructions (tail inpNumbers)
                    "x" -> runMONAD (w              , head inpNumbers,      y,               z) instructions (tail inpNumbers)
                    "y" -> runMONAD (w              , x     , head inpNumbers,               z) instructions (tail inpNumbers)
                    "z" -> runMONAD (w              , x     ,               y, head inpNumbers) instructions (tail inpNumbers)
        "add" -> runMONAD (calculate alu aluVar sec (+))   instructions inpNumbers
        "mul" -> runMONAD (calculate alu aluVar sec (*))   instructions inpNumbers
        "div" -> runMONAD (calculate alu aluVar sec (div)) instructions inpNumbers
        "mod" -> runMONAD (calculate alu aluVar sec (mod)) instructions inpNumbers
        "eql" -> runMONAD (calculate alu aluVar sec (eql)) instructions inpNumbers
    where eql x y = if x==y then 1 else 0

first :: (a,a,a) -> a
first  (x,_,_) = x
second :: (a,a,a) -> a
second (_,y,_) = y
third :: (a,a,a) -> a
third  (_,_,z) = z

parseInput :: [(String, String, String)] -> [(String, String)]
parseInput [] = []
parseInput input = do
    let firstDrop  = drop 5 input
        check      = third $ head $ firstDrop
        secondDrop = drop 10 firstDrop
        offset     = third $ head $ secondDrop
        finalDrop  = drop 3 secondDrop
        in (check, offset) : parseInput finalDrop

stackResult :: [(String, String)] -> [(Int, Int, Int)]
stackResult ((c,o):stackInput) = helper [(c,o,0)] stackInput 1
    where helper _ [] _ = []
          helper stack@((_, topO, c):rest) ((ch, off):input) count
            | ((read ch)::Int)>0   = helper ((ch, off, count):stack) input (count+1)
            | otherwise            = (c, ((read ch)::Int) + ((read topO)::Int), count) : helper rest input (count+1)

maximizeStackResult :: [(Int, Int, Int)] -> [String]
maximizeStackResult [] = []
maximizeStackResult ((id1, num, id2):rest) 
    | num < 0   = ("d[" ++ strID1 ++ "] = 9") : ("d[" ++ strID2 ++ "] = " ++ (show (9+num))) : maximizeStackResult rest
    | otherwise = ("d[" ++ strID2 ++ "] = 9") : ("d[" ++ strID1 ++ "] = " ++ (show (9-num))) : maximizeStackResult rest
    where strID1 = if id1 < 10
                   then "0" ++ (show id1)
                   else (show id1)
          strID2 = if id2 < 10
                   then "0" ++ (show id2)
                   else (show id2)

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input = map (\(x:xs) -> if length xs == 2 
                                then (x, head xs, head $ tail xs)
                                else (x, head xs, []))
                                    (map (\str -> splitBy ' ' str) (lines contents))
    
    {- 
    -- WILL TAKE YEARS, but technically works. Problem 24 lies within the puzzle input (input2.txt in this file's directory)
    -- Basically the problem itself has nothing to do with the wall of text about how ALUs function
    let op = maximum . map snd
    let result = op (filter (\(alu, _) -> if getZ alu == 0 then True else False) 
                  [(runMONAD (0,0,0,0) input (numToDigits num), num) | num<-[11111111111111..99999999999999], (elem 0 (numToDigits num))==False])
    print result
    -}

    -- A link to better explanations than I could ever give for this problem is provided in the first block quote of Day24.md
    let stackInput = parseInput input
    let res        = map last (sort $ maximizeStackResult $ stackResult stackInput)
    print res

---------------------------------------------------------------------------------------------

minimizeStackResult :: [(Int, Int, Int)] -> [String]
minimizeStackResult [] = []
minimizeStackResult ((id1, num, id2):rest) 
    | num < 0   = ("d[" ++ strID2 ++ "] = 1") : ("d[" ++ strID1 ++ "] = " ++ (show (1-num))) : minimizeStackResult rest
    | otherwise = ("d[" ++ strID1 ++ "] = 1") : ("d[" ++ strID2 ++ "] = " ++ (show (1+num))) : minimizeStackResult rest
    where strID1 = if id1 < 10
                   then "0" ++ (show id1)
                   else (show id1)
          strID2 = if id2 < 10
                   then "0" ++ (show id2)
                   else (show id2)

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input = map (\(x:xs) -> if length xs == 2 
                                then (x, head xs, head $ tail xs)
                                else (x, head xs, []))
                                                        (map (\str -> splitBy ' ' str) (lines contents))
    
    {-
    -- WILL TAKE YEARS, but technically works. Problem 24 lies within the puzzle input (input2.txt in this file's directory)
    -- Basically the problem itself has nothing to do with the wall of text about how ALUs function
    let op = minimum . map snd
    let result = op (filter (\(alu, _) -> if getZ alu == 0 then True else False) 
                  [(runMONAD (0,0,0,0) input (numToDigits num), num) | num<-[11111111111111..99999999999999], (elem 0 (numToDigits num))==False])
    print result
    -}
    
    -- A link to better explanations than I could ever give for this problem is provided in the first block quote of Day24.md
    let stackInput = parseInput input
    let res        = map last (sort $ minimizeStackResult $ stackResult stackInput)
    print res
