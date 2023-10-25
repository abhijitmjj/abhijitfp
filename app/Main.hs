module Main where

-- all functions are there in the Lib
import Lib ( solutions', someFunc, subs )

main :: IO ()
main = do
       someFunc
       -- convert list[String] to String
       putStrLn $ concatMap (\x -> show x ++ "\n") (solutions' [1..5] 15)
       -- print (map show $ solutions' [1..5] 15)
       -- foldl (\x y -> x ++ y) "" (map show $ solutions' [1..5] 15)
       -- foldl: foldl f z [x1, x2, ..., xn] = f (... (f (f z x1) x2) ...) xn
       -- foldr: foldr f z [x1, x2, ..., xn] = f x1 (f x2 (... (f xn z) ...))
       print( foldr (\x acc -> x:acc) [] [5,4..1])
       -- cummulative sum of a list
       -- scanl using foldl
       print(foldl (\acc x -> acc ++ [x + last acc]) [0] [1..5])
       -- subsets of a list
       print(subs [1..3])
       return ()
