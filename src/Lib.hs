module Lib
    ( someFunc, Op, valid, apply, eval, choices, 
    subs, interleave, perms, values,
    solutions, solution, split, exprs, combine,
    Expr ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"

-- Number game
data Op = Add | Sub | Mul | Div deriving (Show)

valid :: Op -> Int -> Int -> Bool  
valid Add _ _ = True 
valid Sub x y = x > y
valid Mul _ _ = True 
valid Div x y = x `mod` y == 0

data Expr = Val Int | App Op Expr Expr deriving Show 

apply :: Op -> Int -> Int -> Int 
apply Add x y = x + y
apply Sub x y = x - y
apply Mul x y = x * y 
apply Div x y = x `div` y 

eval :: Expr -> [Int]
eval (Val n) = [n | n > 0]
eval (App o l r) = [apply o x y | x <- eval l, y <- eval r, valid o x y]

-- choices: choose zero or more elements from a list: required for choosing 
 
choices :: [a] -> [[a]]
choices = concatMap perms . subs 

subs :: [a] -> [[a]]
subs [] = [[]]
subs (x:xs) = yss ++ map (x:) yss 
              where yss = subs xs 

interleave :: a -> [a] -> [[a]]
interleave x [] = [[x]]
interleave x (y:ys) = (x:y:ys) : map (y:) (interleave x ys)

perms :: [a] -> [[a]]
perms = foldr (concatMap . interleave) [[]]
-- perms = foldr (concatMap . interleave) [[]]


values :: Expr -> [Int]
values (Val n) = [n]
values (App _ l r) = values l ++ values r 

-- Decide if an expression is a solution for a given list of source 
    -- numbers and a target

solution :: Expr -> [Int] -> Int -> Bool 
solution e ns n = elem (values e) (choices ns) && eval e == [n] 

-- split is a polymorphic function: 
split :: [a] -> [([a],[a])]
split [] = []
split [_] = []
split (x:xs) = ([x],xs) : [(x:ls, rs) | (ls, rs) <- split xs]
-- exprs :: [Int] -> [Expr]
-- returns a list of all possible expressions whose values are precisely
-- a given list of numbers

exprs :: [Int] -> [Expr] -- key function
exprs [] = [] -- empty base case 
exprs [n] = [Val n] -- for one number - just one expr
exprs ns = [e | (ls, rs) <- split ns  -- at least two numbers in ns, all possible pairs
                , l <- exprs ls       -- pairs ls and rs. consider all possible exprs on ls
                , r <- exprs rs       -- all possible exprs on rs,
                , e <- combine l r]   -- combine them - take each resulting l and r expr and
                                      -- combine them (Add, Sub, Mul, Div)

combine :: Expr -> Expr -> [Expr]
combine l r = [App o l r | o <- ops]
ops :: [Op]
ops = [Add, Sub, Mul, Div]

solutions :: [Int] -> Int -> [Expr]
solutions ns n = 
    [e | ns' <- choices ns
         , e <- exprs ns'
         , eval e == [n]
         ]

type Result = (Expr, Int)

results :: [Int] -> [Result]
results [] = []
results [n] = [(Val n, n) | n > 0]
results ns = [(e,m) | 
                      (ls, rs) <- split ns
                    , lx <- results ls
                    , rx <- results rs
                    , (e,m) <- combine' lx rx
                    ]
combine' :: Result -> Result -> [Result]
combine' (l, x) (r, y) = [(App o l r, apply o x y) | o <- ops, valid o x y]

solutions' :: [Int] -> Int -> [Expr]
solutions' ns n = 
    [e | ns' <- choices ns
       , (e,m) <- results ns'
       , m == n]