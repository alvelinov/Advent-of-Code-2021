splitBy :: Char -> String -> [Int]
splitBy delim str = splitBy delim str ""
    where splitBy delim str acc
            | null str                      = [read (reverse acc)::Int]
            | head str == delim && null acc = splitBy delim (tail str) ""
            | head str == delim             = (read (reverse acc)::Int) : splitBy delim (tail str) ""
            | otherwise                     = splitBy delim (tail str) (head str : acc)

increaseBy :: [Int] -> Int -> Int -> [Int]
increaseBy fish pos quantity 
    | pos == 0  = (head fish + quantity) : (tail fish)
    | otherwise = (head fish) : increaseBy (tail fish) (pos - 1) quantity 

expandPopulation :: [Int] -> [Int]
expandPopulation fish = (increaseBy (tail fish) 6 (head fish)) ++ [head fish]

passDays :: [Int] -> Int -> [Int]
passDays population daysLeft
    | daysLeft == 0 = population
    | otherwise     = passDays (expandPopulation population) (daysLeft - 1)

fillPopulation :: [Int] -> [Int]
fillPopulation fish = helper 0
    where helper cnt
            | cnt == 9  = []
            | otherwise = [(length [x | x<-fish, x==cnt])] ++ helper (cnt + 1)

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input           = lines contents
    let population      = fillPopulation $ splitBy ',' (head input)
    let daysToExpand    = 80
    let finalPopulation = passDays population daysToExpand
    let result          = sum finalPopulation
    print result

----------------------------------------------------------------------------------------------

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input           = lines contents
    let population      = fillPopulation $ splitBy ',' (head input)
    let daysToExpand    = 256
    let finalPopulation = passDays population daysToExpand
    let result          = sum finalPopulation
    print result