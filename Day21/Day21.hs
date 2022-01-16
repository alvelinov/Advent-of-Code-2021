nextDeterministicDie :: Int -> Int
nextDeterministicDie 98    = 1
nextDeterministicDie 99    = 2
nextDeterministicDie 100   = 3
nextDeterministicDie die   = die + 3

nextDeterministicRollsSum :: Int -> Int
nextDeterministicRollsSum 98  =  99+100+1
nextDeterministicRollsSum 99  = 100+  1+2
nextDeterministicRollsSum 100 =   1+  2+3
nextDeterministicRollsSum die = 3*(die+2) -- equivalent to (die+1)+(die+2)+(die+3)

updateDeterministicPosition :: Int -> Int -> Int
updateDeterministicPosition pos die = let newPos = (pos + nextDeterministicRollsSum die) `mod` 10
                                        in if newPos == 0 then 10 else newPos

playDeterministicGame :: Int -> Int -> Int
playDeterministicGame p1StartPosition p2StartPosition = helper p1StartPosition p2StartPosition 0 0 100 0 0
    where helper p1Position p2Position p1Points p2Points currDie diceRollsCount lastPlayer
            | p1Points>=1000 = p2Points * diceRollsCount
            | p2Points>=1000 = p1Points * diceRollsCount
            | lastPlayer==0  = 
                let newP1position = updateDeterministicPosition p1Position currDie
                    in helper newP1position p2Position (p1Points+newP1position) p2Points (nextDeterministicDie currDie) (diceRollsCount+3) 1
            | otherwise = 
                let newP2position = updateDeterministicPosition p2Position currDie
                    in helper p1Position newP2position p1Points (p2Points+newP2position) (nextDeterministicDie currDie) (diceRollsCount+3) 0

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let input  = map (\str -> (read str)::Int) (map (\line -> (last$init line) : (last line) : []) (lines contents))
    let result = playDeterministicGame (head input) (last input)
    print result