import Data.List (foldl')

rowChecker :: [Int] -> Int
rowChecker xs = foldl' (\res (l,r) -> if l < r then res+1 else res) 0 (zip xs (tail xs))

readInt :: String -> Int
readInt = read

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName 
    let numbers = map readInt . words $ contents
    print $ rowChecker numbers

-------------------------------------------------------------------------------------------------------------------------

{- Initial variant
windowChecker :: [Int] -> Int
windowChecker xs = if null (drop 3 xs) then 0 else helper (take 3 xs) (drop 3 xs)
    where helper _ [] = 0
          helper window@(_:ys) (x:xs)
            |sum window < sum (ys ++ [x]) = 1 + helper (ys ++ [x]) xs 
            |otherwise                    = helper (ys ++ [x]) xs
-}

windowChecker :: [Int] -> Int
windowChecker xs = if null $ drop 3 xs 
                   then 0 
                   else rowChecker $ zipWith (+) xs $ zipWith (+) (tail xs) (tail $ tail xs)

main2 :: IO ()
main2 = do
        print "Enter the name of the input file: "
        inputFileName <- getLine
        contents      <- readFile inputFileName 
        let numbers = map readInt . words $ contents
        print $ windowChecker numbers