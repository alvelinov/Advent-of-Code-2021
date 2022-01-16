gammaZip :: [Char] -> [Int] -> [Int]
gammaZip [] _ = []
gammaZip (ch:n1) (digit:n2)
    | ch == '1' = digit + 1 : gammaZip n1 n2
    | otherwise = digit - 1 : gammaZip n1 n2

inverse :: [Int] -> [Int]
inverse [] = []
inverse (num:lst)
    | num == 1 = 0 : inverse lst
    | num == 0 = 1 : inverse lst

parse :: [Int] -> [Int]
parse [] = []
parse (digit:nums)
    | digit >= 0     = 1 : parse nums
    | otherwise      = 0 : parse nums

binToDec :: [Int] -> Int
binToDec xs = helper (reverse xs) 1
    where helper []     _      = 0
          helper (x:xs) powOf2 = x * powOf2 + helper xs (powOf2 * 2)

maxDigitsByPosition :: [String] -> [Int]
maxDigitsByPosition numStrings = helper numStrings (take (length $ head numStrings) $ repeat 0)
    where helper []             result = result
          helper (n:numStrings) result = helper numStrings (gammaZip n result)

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents <- readFile inputFileName
    if null contents
    then print 0
    else do
        let gamma   = parse $ maxDigitsByPosition $ lines contents
        let epsilon = inverse gamma
        print (binToDec gamma * binToDec epsilon)

-----------------------------------------------------------------------------------------------------------

binStrToInt :: String -> [Int]
binStrToInt [] = []
binStrToInt str
    | head str == '1' = 1 : binStrToInt (tail str)
    | otherwise       = 0 : binStrToInt (tail str)

majorityFirst :: [String] -> Char
majorityFirst xxs = helper xxs 0
    where helper [] result = if result >= 0 then '1' else '0'
          helper ((x:_):xxs) result
            | x == '1'  = helper xxs (result + 1)
            | otherwise = helper xxs (result - 1)

oxygenFilter :: [String] -> [Int]
oxygenFilter [xs] = binStrToInt xs
oxygenFilter xxs
    | majorityFirst xxs == '1' = 1 : oxygenFilter (map tail [xs | xs <- xxs, head xs == '1'])
    | otherwise                = 0 : oxygenFilter (map tail [xs | xs <- xxs, head xs == '0'])

minorityFirst :: [String] -> Char
minorityFirst xxs = helper xxs 0
    where helper [] result = if result >= 0 then '0' else '1'
          helper ((x:_):xxs) result
            | x == '1'  = helper xxs (result + 1)
            | otherwise = helper xxs (result - 1)

co2Filter :: [String] -> [Int]
co2Filter [xs] = binStrToInt xs
co2Filter xxs
    | minorityFirst xxs == '1' = 1 : co2Filter (map tail [xs | xs <- xxs, head xs == '1'])
    | otherwise                = 0 : co2Filter (map tail [xs | xs <- xxs, head xs == '0']) 

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents <- readFile inputFileName
    if null contents
    then print 0
    else do
        let inputNumbers = lines contents
        let oxygen       = oxygenFilter inputNumbers
        let co2          = co2Filter inputNumbers
        print (binToDec oxygen * binToDec co2)
