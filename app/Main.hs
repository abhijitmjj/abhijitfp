module Main where

-- all functions are there in the Lib
import Lib

main :: IO ()
main = do
       someFunc
       -- convert list[String] to String
       putStrLn $ concatMap (\x -> show x ++ "\n") (solutions' [1..5] 15)
       -- print (map show $ solutions' [1..5] 15)
       return ()
