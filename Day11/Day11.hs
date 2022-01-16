import Data.Char (digitToInt)
import Data.Array

createAndFillArray :: [Int] -> Int -> Int -> Array (Int, Int) Int
createAndFillArray input rowsNum colsNum = listArray ((0,0),(rowsNum-1, colsNum-1)) input

chargeUnflashed :: Int -> Int
chargeUnflashed num = if num == 0 then num else num+1

spreadFlash :: Int -> Int -> Array (Int, Int) Int -> Array (Int, Int) Int
spreadFlash i j initialArr = helper initialArr (fst $ snd $ bounds initialArr) (snd $ snd $ bounds initialArr)
  where helper arr rowSize colSize = arr//[((l,r), chargeUnflashed el) | ((l,r),el)<-(neighbours i j rowSize colSize)]
          where neighbours i j rowSize colSize
                    | i==0 && j==0             = [((i+1,j),(!) arr (i+1,j)), ((i+1,j+1),(!) arr (i+1,j+1)), ((i,j+1),(!) arr (i,j+1))]
                    | i==rowSize && j==0       = [((i-1,j),(!) arr (i-1,j)), ((i-1,j+1),(!) arr (i-1,j+1)), ((i,j+1),(!) arr (i,j+1))]
                    | i==0 && j==colSize       = [((i+1,j),(!) arr (i+1,j)), ((i+1,j-1),(!) arr (i+1,j-1)), ((i,j-1),(!) arr (i,j-1))]
                    | i==rowSize && j==colSize = [((i-1,j),(!) arr (i-1,j)), ((i-1,j-1),(!) arr (i-1,j-1)), ((i,j-1),(!) arr (i,j-1))]
                    | i==0                     = [((i,j-1),(!) arr (i,j-1)), ((i+1,j-1),(!) arr (i+1,j-1)), ((i+1,j),(!) arr (i+1,j)), 
                                                                             ((i+1,j+1),(!) arr (i+1,j+1)), ((i,j+1),(!) arr (i,j+1))]
                    | i==rowSize               = [((i,j-1),(!) arr (i,j-1)), ((i-1,j-1),(!) arr (i-1,j-1)), ((i-1,j),(!) arr (i-1,j)),
                                                                             ((i-1,j+1),(!) arr (i-1,j+1)), ((i,j+1),(!) arr (i,j+1))]
                    | j==0                     = [((i-1,j),(!) arr (i-1,j)), ((i-1,j+1),(!) arr (i-1,j+1)), ((i,j+1),(!) arr (i,j+1)),
                                                                             ((i+1,j+1),(!) arr (i+1,j+1)), ((i+1,j),(!) arr (i+1,j))]
                    | j==colSize               = [((i-1,j),(!) arr (i-1,j)), ((i-1,j-1),(!) arr (i-1,j-1)), ((i,j-1),(!) arr (i,j-1)),
                                                                             ((i+1,j-1),(!) arr (i+1,j-1)), ((i+1,j),(!) arr (i+1,j))]
                    | otherwise                = [((i-1,j-1),(!) arr (i-1,j-1)), ((i-1,j),(!) arr (i-1,j)), ((i-1,j+1),(!) arr (i-1,j+1)),
                                                  ((i,  j-1),(!) arr (i,  j-1)),                            ((i,  j+1),(!) arr (i,  j+1)),
                                                  ((i+1,j-1),(!) arr (i+1,j-1)), ((i+1,j),(!) arr (i+1,j)), ((i+1,j+1),(!) arr (i+1,j+1))]

applyFlashes :: Array (Int, Int) Int -> (Array (Int, Int) Int, Bool)
applyFlashes arr = helper arr (assocs arr) False
    where helper moddedArr [] changeTracker = (moddedArr, changeTracker)
          helper moddedArr (((i,j),el):elementList) changeTracker
            | el > 9    = helper (spreadFlash i j (moddedArr//[((i,j),0)])) elementList True
            | otherwise = helper moddedArr elementList changeTracker


flash :: Array (Int, Int) Int -> Array (Int, Int) Int
flash arr = let res             = applyFlashes arr
                changesWereMade = (snd $ res)
                resultArray     = (fst $ res)
                in if changesWereMade then flash resultArray else resultArray

flashesAfterXsteps :: Array (Int, Int) Int -> Int -> Int
flashesAfterXsteps initialArr stepsLeft = helper initialArr stepsLeft 0
    where helper _   0        flashesCount = flashesCount
          helper arr stepsLeft flashesCount =
            let afterFlashes = flash (arr//[((i,j), succ el) | ((i,j), el)<-(assocs arr)])
                in helper afterFlashes (stepsLeft-1) (flashesCount + (length $ filter (==0) (map snd (assocs afterFlashes))))

main1 :: IO ()
main1 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let rawInput    = map (\str -> map digitToInt str) (lines contents)
    let rowsNum     = length $ head rawInput
    let colsNum     = length $ map head rawInput
    let input       = foldr (++) [] rawInput
    let parsedArray = createAndFillArray input rowsNum colsNum
    let result      = flashesAfterXsteps parsedArray 100
    print result

-------------------------------------------------------------------------------------------------

stepOfSync :: Array (Int, Int) Int -> Int
stepOfSync initialArr = helper initialArr 0
    where helper arr stepsPassed
            | flashesNum arr == arrSize arr = stepsPassed
            | otherwise                     = helper (flash (arr//[((i,j), succ el) | ((i,j), el)<-(assocs arr)])) (stepsPassed+1)
          flashesNum arr = (length $ filter (==0) (map snd (assocs arr)))
          arrSize arr    = ((fst $ snd $ bounds arr) - (fst $ fst $ bounds arr) + 1) * ((snd $ snd $ bounds arr) - (snd $ fst $ bounds arr) + 1)

main2 :: IO ()
main2 = do
    print "Enter the name of the input file: "
    inputFileName <- getLine
    contents      <- readFile inputFileName
    let rawInput    = map (\str -> map digitToInt str) (lines contents)
    let rowsNum     = length $ head rawInput
    let colsNum     = length $ map head rawInput
    let input       = foldr (++) [] rawInput
    let parsedArray = createAndFillArray input rowsNum colsNum
    let result      = stepOfSync parsedArray
    print result