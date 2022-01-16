splitBy :: Char -> String -> [Int]
splitBy delim str = splitBy delim str ""
    where splitBy delim str acc
            | null str                      = [read (reverse acc)::Int]
            | head str == delim && null acc = splitBy delim (tail str) ""
            | head str == delim             = (read (reverse acc)::Int) : splitBy delim (tail str) ""
            | otherwise                     = splitBy delim (tail str) (head str : acc)

cumulativeDistances :: [Int] -> Int -> Int -> [Int]
cumulativeDistances crabs start end = cumulativeDistances start end
    where cumulativeDistances start end
            | start > end = []
            | otherwise   = (sum(map (\x -> abs (x-start)) crabs)) : cumulativeDistances (start + 1) end

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let line      = head $ lines contents
    let crabs     = splitBy ',' line
    let start     = minimum crabs
    let end       = maximum crabs
    let distances = cumulativeDistances crabs start end
    print $ minimum distances

---------------------------------------------------------------------------------------------------

cumulativeDistances2 :: [Int] -> Int -> Int -> [Int]
cumulativeDistances2 crabs start end = cumulativeDistances2 start end
    where cumulativeDistances2 start end
            | start > end = []
            | otherwise   = (sum(map (\x -> abs (x-start) * (abs (x-start) + 1) `div` 2) crabs)) : cumulativeDistances2 (start + 1) end

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let line      = head $ lines contents
    let crabs     = splitBy ',' line
    let start     = minimum crabs
    let end       = maximum crabs
    let distances = cumulativeDistances2 crabs start end
    print $ minimum distances