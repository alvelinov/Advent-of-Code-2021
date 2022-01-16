import Data.Char (isDigit)
import Data.List (foldl')

getnum :: String -> Int
getnum = read . dropWhile (not . isDigit)

parse1 :: String -> (Int, Int)
parse1 (ch:str)
    | ch == 'd' = (0, getnum str)
    | ch == 'f' = (getnum str, 0)
    | ch == 'u' = (0, -(getnum str))

sumCouples :: [(Int, Int)] -> (Int, Int)
sumCouples = foldl' (\(resLeft, resRight) (l, r) -> (resLeft+l, resRight+r)) (0,0)

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents <- readFile inputFileName
    let instructions = sumCouples $ map parse1 $ lines contents
    let result       = fst instructions * snd instructions
    print result

-----------------------------------------------------------------------------------------

first :: (a, a, a) -> a
first  (x,_,_) = x
second :: (a, a, a) -> a
second (_,y,_) = y
third :: (a, a, a) -> a
third  (_,_,z) = z

parse2 :: String -> (Int, Int, Int) -> (Int, Int, Int)
parse2 str prev
    |head str == 'd' = (0, 0, getnum str)
    |head str == 'f' = (getnum str, getnum str * third prev, 0)
    |head str == 'u' = (0, 0, -(getnum str))

followInstructions :: [String] -> (Int, Int, Int)
followInstructions strings = helper (0, 0, 0) strings
    where helper acc [] = acc
          helper (x1, y1, z1) (s:strings) = helper (x1+x2, y1+y2, z1+z2) strings
            where (x2, y2, z2) = parse2 s (x1, y1, z1)

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let instructions = lines contents
    let result       = followInstructions instructions
    print $ first result * second result