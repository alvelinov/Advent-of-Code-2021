hexToBin :: [Char] -> [Char]
hexToBin [] = []
hexToBin (ch:hexStr) = helper ch ++ hexToBin hexStr
    where helper ch = case ch of
            '0' -> "0000"
            '1' -> "0001"
            '2' -> "0010"
            '3' -> "0011"
            '4' -> "0100"
            '5' -> "0101"
            '6' -> "0110"
            '7' -> "0111"
            '8' -> "1000"
            '9' -> "1001"
            'A' -> "1010"
            'B' -> "1011"
            'C' -> "1100"
            'D' -> "1101"
            'E' -> "1110"
            'F' -> "1111"

binStrToInt :: [Char] -> Int
binStrToInt str = helper (reverse str) 1 0
    where helper [] _ acc             = acc
          helper (c:chars) powOf2 acc = 
            if c == '1'
            then helper chars (2*powOf2) (acc + powOf2)
            else helper chars (2*powOf2) acc


