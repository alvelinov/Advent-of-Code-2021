import Data.Char(intToDigit, digitToInt)

isDigit :: Char -> Bool
isDigit ch = ch >= '0' && ch <='9'

intToString :: Int -> String
intToString num = if num==0 then ['0'] else helper num []
    where helper 0 acc = (map intToDigit acc)
          helper x acc = helper (x `div` 10) (x `mod` 10 : acc)

addUpSnailNumbers :: String -> String -> String
addUpSnailNumbers snailNum1 snailNum2 = ['['] ++ snailNum1 ++ [','] ++ snailNum2 ++ [']']

trySplit :: String -> String
trySplit [] = []
trySplit snailNumber@(el:rest) 
    | isDigit el = if length (nextNumber snailNumber) > 1 
                    then (makePair (nextNumber snailNumber)) ++ (dropWhile isDigit snailNumber)
                    else el: trySplit rest
    | otherwise   = el: trySplit rest
    where nextNumber str = takeWhile isDigit str
          makePair str = let num = (read str)::Int
                             leftNum = num `div` 2
                             rightNum = num - leftNum
                             in ['['] ++ (intToString leftNum) ++ [','] ++ (intToString rightNum) ++ [']']

takeBasicSnailNumber :: String -> String
takeBasicSnailNumber str = (takeWhile (/= ']') str) ++ [']']

dropBasicSnailNumber :: String -> String
dropBasicSnailNumber str = tail $ dropWhile (/=']') str

leftNumber :: String -> String
leftNumber snailNumber = takeWhile isDigit (tail snailNumber)

rightNumber :: String -> String
rightNumber snailNumber = takeWhile isDigit (tail $ dropWhile isDigit (tail snailNumber))

putTogetherSnailNum :: String -> String -> String -> String
putTogetherSnailNum leftPart snailNumber rightPart = 
    (insertLeft leftPart [] (leftNumber snailNumber)) ++ ['0'] ++ (insertRight rightPart (rightNumber snailNumber))
    where insertLeft [] acc  _ = acc
          insertLeft leftPart@(el:rest) acc digitString
            | isDigit el = (reverse (dropWhile isDigit rest)) ++ (show (((read $ reverse $ takeWhile isDigit leftPart)::Int) + ((read digitString)::Int))) ++ acc
            | otherwise  = insertLeft rest (el:acc) digitString
          insertRight [] _ = []
          insertRight rightPart@(el:rest) digitString
            | isDigit el = (show (((read $ takeWhile isDigit rightPart)::Int) + (read digitString)::Int)) ++ (dropWhile isDigit rightPart)
            | otherwise  = el : insertRight rest digitString

tryExplode :: String -> String
tryExplode snailNumber = helper [] snailNumber 0
    where helper leftPart [] _ = (reverse leftPart)
          helper leftPart snailNumber@(el:rest) openingBrackets
            | openingBrackets == 4 && el == '[' = putTogetherSnailNum leftPart (takeBasicSnailNumber snailNumber) (dropBasicSnailNumber snailNumber)
            | el == '[' = helper (el:leftPart) rest (openingBrackets+1)
            | el == ']' = helper (el:leftPart) rest (openingBrackets-1)
            | otherwise = helper (el:leftPart) rest openingBrackets

reduceSnailNumber :: String -> String
reduceSnailNumber snailNumber 
    | snailNumber /= explodedNumber = reduceSnailNumber explodedNumber
    | snailNumber /= splitNumber    = reduceSnailNumber splitNumber
    | otherwise                     = snailNumber
    where explodedNumber = tryExplode snailNumber
          splitNumber    = trySplit   snailNumber

addUpSnailNumberWithList :: String -> [String] -> String
addUpSnailNumberWithList snailNumber [] = snailNumber
addUpSnailNumberWithList snailNumber (nextSnailNumber:snailNumberList)
        = addUpSnailNumberWithList (reduceSnailNumber $ addUpSnailNumbers snailNumber nextSnailNumber) snailNumberList

getLeftSnailNumber :: String -> String
getLeftSnailNumber snailNumber = helper (tail snailNumber) 0
    where helper (el:snailStr) openingBrackets 
            | el == ']' && openingBrackets == 1 = [']']
            | el == ']'                         = el : helper snailStr (openingBrackets-1)
            | el == '['                         = el : helper snailStr (openingBrackets+1)
            | otherwise                         = el : helper snailStr openingBrackets

getRightSnailNumber :: String -> String
getRightSnailNumber snailNumber = helper (tail snailNumber) 0
     where helper (el:snailStr) openingBrackets 
            | el == ']' && openingBrackets == 1 = tail $ init snailStr
            | el == ']'                         = helper snailStr (openingBrackets-1)
            | el == '['                         = helper snailStr (openingBrackets+1)
            | otherwise                         = helper snailStr openingBrackets

magnitude :: String -> Int
magnitude snailNumber@(el:snailTail)
    | isDigit el            = (read $ takeWhile isDigit snailNumber)::Int
    | head snailTail == '[' = 3 * (magnitude $ getLeftSnailNumber snailNumber) + 2 * (magnitude $ getRightSnailNumber snailNumber)
    | otherwise             = 3 * ((read $ leftNumber snailNumber)::Int) + 
                              2 * (if isDigit $ head $ tail $ dropWhile isDigit snailTail 
                                  then ((read $ rightNumber snailNumber)::Int)
                                  else magnitude $ tail $ dropWhile isDigit snailTail)

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input  = lines contents
    let result = magnitude $ addUpSnailNumberWithList (head input) (tail input)
    print result

-------------------------------------------------------------------------------------------

-- Takes about a minute for the bigger input, but does the job
main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input  = lines contents
    let result = maximum [magnitude $ reduceSnailNumber $ addUpSnailNumbers first second | first <- input, second <- input, first /= second]
    print result
          