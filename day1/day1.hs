import Data.List.Split
import Data.List
import Data.Char

rotate :: Int -> Char -> Int -> Int
rotate pos 'R' amount
    | pos + amount > 99 = (pos + amount) - 100
    | otherwise = pos + amount
rotate pos 'L' amount
    | pos - amount < 0 = 100 + (pos - amount)
    | otherwise = pos - amount

get0Passes :: Char -> Int -> Int -> Int
get0Passes d amount pos
    | pos == 0 = 0
    | (amount < 100) && (d == 'R') && (amount + pos > 100) = 1
    | (amount < 100) && (d == 'L') && (pos - amount < 0) = 1
    | amount < 100 = 0
    | otherwise = quot amount 100 + get0Passes d (mod amount 100) pos

isOn0 :: Int -> Int
isOn0 0 = 1
isOn0 _ = 0

solve1 :: [String] -> Int -> Int -> Int -> Int
solve1 input i pos acc
    | (i < length input) && (pos == 0) = solve1 input (i + 1) (rotate pos (head (input !! i)) (mod ((read::String->Int) (tail (input !! i))) 100)) (acc + 1)
    | i < length input = solve1 input (i + 1) (rotate pos (head (input !! i)) (mod ((read::String->Int) (tail (input !! i))) 100)) acc
    | pos == 0 = acc + 1
    | otherwise = acc

solve2 :: [String] -> Int -> Int -> Int -> Int -- TODO: finish, figure out why result still off by ~1200
solve2 input i pos acc
    | i < length input = solve2 input (i + 1) (rotate pos (head (input !! i)) (mod ((read::String->Int) (tail (input !! i))) 100)) (acc + get0Passes (head (input !! i)) ((read::String->Int) (tail (input !! i))) pos + isOn0 pos)
    | otherwise = acc + isOn0 pos

main :: IO ()
main = do
    input_file <- readFile "day1/input.txt"
    let lines = splitOn "\n" input_file
    print (solve1 lines 0 50 0)
    print (solve2 lines 0 50 0)
    return ()