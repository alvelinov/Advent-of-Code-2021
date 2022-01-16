import Data.Char (isUpper, isLower)

splitBy :: String -> Char -> [String]
splitBy [] _ = []
splitBy str@(c:rest) delim 
    | c == delim  = splitBy rest delim
    | otherwise   = (takeWhile (/= delim) str) : splitBy (dropWhile (/= delim) str) delim

toSet :: (Eq a) => [a] -> [a]
toSet []     = []
toSet (x:xs) = if x `elem` xs then toSet xs else x : toSet xs

makeAdjacencyList :: (Eq a) => [(a, a)] -> [(a,[a])]
makeAdjacencyList pairs = helper pairs (zip (toSet $ map fst pairs) (repeat []))
    where helper [] adjList = adjList
          helper ((node, neighbour):pairs) adjList = helper pairs (addNeighbour node neighbour adjList)
          addNeighbour node neighbour ((n,xs):adjList)
            | node == n = (n, neighbour:xs) : adjList
            | otherwise = (n, xs) : addNeighbour node neighbour adjList

allPathsDFS :: [(String, [String])] -> Int
allPathsDFS adjList = helper adjList ["start"]
    where helper adjList stack@(top:_)
            | top == "end" = 1
            | otherwise    =  
                let nextSteps = [ ((helper), (neighbour:stack)) | (node, neighbours) <- adjList, neighbour <- neighbours,
                                  node == top, (isUpper $ head neighbour) || neighbour `notElem` stack ]
                in  if length nextSteps == 0
                    then 0
                    else sum $ map (\(func, st) -> func adjList st) nextSteps

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let rawInput   = map (\str -> splitBy str '-') (lines contents)
    let inputPairs = zip (map head rawInput) (map last rawInput)
    let input      = makeAdjacencyList (inputPairs ++ (map (\(f,s) -> (s,f)) inputPairs))
    print $ allPathsDFS input

--------------------------------------------------------------------------------------------------------------

getNeighbours :: String -> [(String, [String])] -> [String]
getNeighbours parent ((k,v):graph)
    | k == parent = v
    | otherwise = getNeighbours parent graph

allPathsOneRepetitionDFS :: [(String, [String])] -> Int
allPathsOneRepetitionDFS adjList = helper adjList (getNeighbours "start" adjList) ["start"] []
    where helper _ [] _ _ = 0
          helper adjList (neighbour:neighbours) stack repeatedNode
            | neighbour == "end"                        = 1 + helper adjList  neighbours                            stack          repeatedNode
            | isUpper $ head neighbour                  =     helper adjList (getNeighbours neighbour adjList)      stack          repeatedNode
                                                            + helper adjList  neighbours                            stack          repeatedNode
            | neighbour `notElem` stack                 =     helper adjList (getNeighbours neighbour adjList) (neighbour:stack)   repeatedNode
                                                            + helper adjList  neighbours                            stack          repeatedNode 
            | null repeatedNode && neighbour /= "start" =     helper adjList (getNeighbours neighbour adjList)      stack           [neighbour]
                                                            + helper adjList  neighbours                            stack          repeatedNode
            | otherwise                                 =     helper adjList  neighbours                            stack          repeatedNode

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let rawInput   = map (\str -> splitBy str '-') (lines contents)
    let inputPairs = zip (map head rawInput) (map last rawInput)
    let input      = makeAdjacencyList (inputPairs ++ (map (\(f,s) -> (s,f)) inputPairs))
    print $ allPathsOneRepetitionDFS input