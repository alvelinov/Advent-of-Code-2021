import Data.List

getLowercaseStrings :: String -> [String]
getLowercaseStrings str = getLowercaseStrings str ""
    where getLowercaseStrings str acc
            | null str && null acc                        = []
            | null str                                    = [reverse acc]
            | (not $ isLowercase $ head str)  && null acc = getLowercaseStrings (tail str) ""
            | not $ isLowercase $ head str                = reverse acc : getLowercaseStrings (tail str) ""
            | otherwise                                   = getLowercaseStrings (tail str) (head str : acc)
            where isLowercase c = c>='a' && c<='z'

getUniqueCombinationsNum :: [String] -> Int
getUniqueCombinationsNum [] = 0
getUniqueCombinationsNum (x:xs)
    | isUnique $ length x = 1 + getUniqueCombinationsNum xs
    | otherwise           = getUniqueCombinationsNum xs
    where isUnique num = num `elem` [2,3,4,7]

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let cyphers = map getLowercaseStrings (lines contents)
    let result  = sum $ map getUniqueCombinationsNum (map (\cypher -> drop 10 cypher) cyphers)
    print result

-------------------------------------------------------------------------------------------------

combineStringCodes :: [String] -> String
combineStringCodes [] = []
combineStringCodes (str:strings) = str ++ combineStringCodes strings

occurences :: Char -> String -> Int
occurences _ [] = 0
occurences ch (c:str)
    | c == ch   = 1 + occurences ch str
    | otherwise = occurences ch str

removeAll :: Char -> String -> String
removeAll _ [] = []
removeAll ch (c:str)
    | c == ch   = removeAll ch str
    | otherwise = c : removeAll ch str

histogram :: String -> [(Char, Int)]
histogram [] = []
histogram (ch:str) = (ch, 1 + occurences ch str) : histogram (removeAll ch str)

getEasySegmentsCodes :: [(Char, Int)] -> [(Char, Int)]
getEasySegmentsCodes [] = []
getEasySegmentsCodes ((c, i):histogram) = 
    case i of 
        4 -> (c, 5) : getEasySegmentsCodes histogram
        6 -> (c, 2) : getEasySegmentsCodes histogram
        9 -> (c, 6) : getEasySegmentsCodes histogram
        _ -> getEasySegmentsCodes histogram

findByKey :: Char -> [(Char, Int)] -> Bool
findByKey ch [] = False
findByKey ch ((c, i):pairs) = if ch == c then True else findByKey ch pairs    

includeThrees :: [String] -> [[(Char, Int)]] -> [[(Char, Int)]]
includeThrees [] _ = []
includeThrees (o:ones) (d:decodedSegments) = 
    if findByKey (head o) d 
    then ((head $ tail o, 3) : d) : includeThrees ones decodedSegments
    else ((head o, 3) : d) : includeThrees ones decodedSegments

includeOnes :: [[(Char, Int)]] -> [[(Char, Int)]] -> [[(Char, Int)]]
includeOnes [] _ = []
includeOnes (h:histograms) (d:decodedSegments)
    | findByKey (fst $ head candidates) d = ((fst $ head $ tail candidates, 1) : d) : includeOnes histograms decodedSegments
    | otherwise                           = ((fst $ head candidates, 1) : d) : includeOnes histograms decodedSegments
    where candidates = [(c, i) | (c,i) <- h, i==8] -- always a list with 2 elements

findUnmappableChar :: [Char] -> [(Char, Int)] -> Char
findUnmappableChar (s:str) decodedSegments =
    if findByKey s decodedSegments
    then findUnmappableChar str decodedSegments
    else s

includeFours :: [String] -> [[(Char, Int)]] -> [[(Char, Int)]]
includeFours [] _ = []
includeFours (f:fours) (d:decodedSegments) = ((findUnmappableChar f d, 4) : d) : includeFours fours decodedSegments

includeSevens :: [[(Char, Int)]] -> [[(Char, Int)]]
includeSevens [] = []
includeSevens (d:decodedSegments) = ((findUnmappableChar "abcdefg" d, 7) : d) : includeSevens decodedSegments

getSegment :: Char -> [(Char, Int)] -> Int
getSegment ch ((c,i):codes) =
    if ch == c 
    then i
    else getSegment ch codes

mapOutputs :: [[(Char, Int)]] -> [[String]] -> [[[Int]]]
mapOutputs [] _ = []
mapOutputs (c:codes) (o:outputs) = map (\str -> map (\ch -> getSegment ch c) str) o : mapOutputs codes outputs

segmentsToDigit :: [Int] -> Int
segmentsToDigit segments = 
    case sort segments of
        [1,2,3,5,6,7]   -> 0
        [3,6]           -> 1
        [1,3,4,5,7]     -> 2
        [1,3,4,6,7]     -> 3
        [2,3,4,6]       -> 4
        [1,2,4,6,7]     -> 5
        [1,2,4,5,6,7]   -> 6
        [1,3,6]         -> 7
        [1,2,3,4,5,6,7] -> 8
        [1,2,3,4,6,7]   -> 9

arrToNumber :: [Int] -> Int
arrToNumber arr = helper arr 0
    where helper [] acc = acc
          helper (a:arr) acc = helper arr (10*acc + a)

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let cyphers           = map getLowercaseStrings (lines contents)
    let codes             = map (\x -> sortOn length x) (map (\x -> take 10 x) cyphers)
    let outputs           = map (\x -> drop 10 x) cyphers
    let histograms        = map histogram (map combineStringCodes codes)
    let easySegmentsCodes = map getEasySegmentsCodes histograms -- gets char codings of segments 2, 5, and 6 
    let includedThrees    = includeThrees (map head codes) easySegmentsCodes
    let includedOnes      = includeOnes histograms includedThrees
    let includedFours     = includeFours (map (\x -> head $ tail $ tail x) codes) includedOnes
    let decypheredKeys    = includeSevens includedFours
    let decodedOutputs    = mapOutputs decypheredKeys outputs
    let result            = sum $ map (\arr -> arrToNumber arr) (map (\x -> map (\seq -> segmentsToDigit seq) x) decodedOutputs)
    print result
    