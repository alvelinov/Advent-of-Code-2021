import Data.List (sortOn)

isUpper :: Char -> Bool
isUpper ch
    | ch >= 'A' && ch <= 'Z' = True
    | otherwise              = False

getUppercaseStrings :: String -> [String]
getUppercaseStrings str = helper str ""
    where helper str acc
            | null str                              = [reverse acc]
            | not (isUpper (head str))  && null acc = helper (tail str) ""
            | not (isUpper (head str))              = (reverse acc) : helper (tail str) ""
            | otherwise                             = helper (tail str) (head str : acc)

transpose :: [[a]] -> [[a]]
transpose matrix@(h:_) = if null h then [] else map head matrix : (transpose $ map tail matrix)

getValueByKey :: String -> [(String, String)] -> String
getValueByKey _ [] = []
getValueByKey keyStr ((k,v):pairs) = if keyStr == k then v else getValueByKey keyStr pairs

passOneStep :: String -> [(String, String)] -> String
passOneStep [a] _ = [a]
passOneStep (x:y:str) rules = [x] ++ (getValueByKey (x:y:[]) rules) ++ passOneStep (y:str) rules

passNSteps :: Int -> String -> [(String, String)] -> String
passNSteps 0 string _ = string
passNSteps stepsLeft string rules = passNSteps (stepsLeft-1) (passOneStep string rules) rules

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

-- Naiive approach, unbelievably slow for more than 10 steps
main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input           = lines contents
    let initialString   = head input
    let rulesParts      = transpose $ map getUppercaseStrings (drop 2 input)
    let rules           = zip (head rulesParts) (head $ tail rulesParts)
    let afterTenSteps   = passNSteps 10 initialString rules
    let resultHistogram = sortOn snd (histogram afterTenSteps)
    let result          = (snd $ last resultHistogram) - (snd $ head resultHistogram)
    print result

----------------------------------------------------------------------------------------------------------

initializeTracker :: String -> [(String, Int)] -> [(String, Int)]
initializeTracker [] tracker = tracker
initializeTracker [x] tracker = tracker
initializeTracker (x:y:initialString) tracker = initializeTracker (y:initialString) (helper [x,y] tracker)
    where helper keyStr [] = []
          helper keyStr ((k, count):pairs)
            | keyStr == k = (k,count+1) : pairs
            | otherwise   = (k,count) : helper keyStr pairs

updateValue :: String -> Int -> [(String, Int)] -> [(String, Int)]
updateValue key value [] = []
updateValue key value ((k,v):newSet)
    | key == k    = (k, v + value) : newSet
    | otherwise   = (k, v) : updateValue key value newSet

updateWith :: String -> Int -> [(String, Int)] -> [(String, String)] -> [(String, Int)]
updateWith key value newSet keyValueSet = 
    updateValue (head key : middleValue) value (updateValue (middleValue ++ (tail key)) value newSet)
    where middleValue = getValueByKey key keyValueSet

afterOneStep :: [(String, Int)] -> [(String, String)] -> [(String, Int)]
afterOneStep trackingSet keyValueSet = helper trackingSet (zip (map fst trackingSet) (repeat 0)) keyValueSet
    where helper []             newSet _           = newSet
          helper ((k,v):oldSet) newSet keyValueSet = helper oldSet (updateWith k v newSet keyValueSet) keyValueSet

afterStepX :: [(String, Int)] -> [(String, String)] -> Int -> [(String, Int)]
afterStepX trackingSet _           0         = trackingSet
afterStepX trackingSet keyValueSet stepsLeft = afterStepX (afterOneStep trackingSet keyValueSet) keyValueSet (stepsLeft-1)

toSet :: (Eq a) => [a] -> [a]
toSet [] = []
toSet (el:arr) = if elem el arr then toSet arr else el:(toSet arr) 

lettersHistogram :: [(String, Int)] -> [(String, Int)]
lettersHistogram [] = []
lettersHistogram pairsToSplit = helper pairsToSplit (zip (map (:[]) (toSet (foldr (++) [] (map fst pairsToSplit)))) (repeat 0))
    where helper [] hist                  = (map (\(s, v) -> (s, v `div` 2)) hist)
          helper ((pair, val):pairs) hist = helper pairs (updateValue (tail pair) val (updateValue [(head pair)] val hist))

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input           = lines contents
    let initialString   = head input
    let rulesParts      = transpose $ map getUppercaseStrings (drop 2 input)
    let rules           = zip (head rulesParts) (head $ tail rulesParts)
    let trackingSet     = initializeTracker initialString (zip (head rulesParts) (repeat 0))
    let afterNsteps     = afterStepX trackingSet rules 40
    let lettersHist     = updateValue [last initialString] 1 (updateValue [head initialString] 1 (lettersHistogram afterNsteps))
    let result          = let values = map snd lettersHist
                            in maximum values - minimum values
    print result
