import Data.List (sort)

lineFirstPenaltyCost :: [Char] -> Int
lineFirstPenaltyCost []             = 0
lineFirstPenaltyCost (b:bracketStr) = helper [b] bracketStr
    where helper _ [] = 0
          helper stack (b:brackets) 
                  | b==')'    = if null stack || head stack/='(' then 3     else helper (tail stack) brackets
                  | b==']'    = if null stack || head stack/='[' then 57    else helper (tail stack) brackets
                  | b=='}'    = if null stack || head stack/='{' then 1197  else helper (tail stack) brackets
                  | b=='>'    = if null stack || head stack/='<' then 25137 else helper (tail stack) brackets
                  | otherwise = helper (b:stack) brackets

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input  = lines contents
    let result = sum $ map lineFirstPenaltyCost input
    print result

----------------------------------------------------------------------------------------

invertOpeningBracketList :: [Char] -> [Char]
invertOpeningBracketList [] = []
invertOpeningBracketList brackets = helper brackets
    where helper [] = []
          helper (b:brackets) = 
            case b of 
                '(' -> ')' : helper brackets
                '[' -> ']' : helper brackets
                '{' -> '}' : helper brackets
                '<' -> '>' : helper brackets

getLineComplement :: [Char] -> [Char]
getLineComplement [] = []
getLineComplement (b:brackets) = helper [b] brackets
    where helper stack [] = invertOpeningBracketList stack
          helper stack (b:brackets)
            | b==')'    = if null stack || head stack/='(' then [] else helper (tail stack) brackets
            | b==']'    = if null stack || head stack/='[' then [] else helper (tail stack) brackets
            | b=='}'    = if null stack || head stack/='{' then [] else helper (tail stack) brackets
            | b=='>'    = if null stack || head stack/='<' then [] else helper (tail stack) brackets
            | otherwise = helper (b:stack) brackets

-- expects a string of closing brackets
complementScore :: [Char] -> Int
complementScore brackets = helper 0 brackets
    where helper acc [] = acc
          helper acc (b:brackets)
            | b==')' = helper (acc * 5 + 1) brackets
            | b==']' = helper (acc * 5 + 2) brackets
            | b=='}' = helper (acc * 5 + 3) brackets
            | b=='>' = helper (acc * 5 + 4) brackets

medianOfSortedWithOddLength :: (Num a) => [a] -> a
medianOfSortedWithOddLength []          = 0
medianOfSortedWithOddLength [num]       = num
medianOfSortedWithOddLength (n:numbers) = medianOfSortedWithOddLength $ init numbers

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input  = lines contents
    let result = medianOfSortedWithOddLength $ dropWhile (==0) (sort $ map complementScore (map getLineComplement input))
    print result