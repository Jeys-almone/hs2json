module Prettify
    ( Doc
    , empty
    , char
    , text
    , double
    , line
    , (<>)
    , hcat
    , punctuate
    , compact
    ) where

import Prelude hiding ((<>))

infixr 6 <>

data Doc
    = Empty
    | Char Char
    | Text String
    | Line
    | Concat Doc Doc
    deriving (Show, Eq)

empty :: Doc
empty = Empty

char :: Char -> Doc
char c = Char c

text :: String -> Doc
text "" = Empty
text s  = Text s

double :: Double -> Doc
double n = text (show n)

line :: Doc
line = Line

(<>) :: Doc -> Doc -> Doc
Empty <> y = y
x <> Empty = x
x <> y     = Concat x y

hcat :: [Doc] -> Doc
hcat = foldr (<>) empty

punctuate :: Doc -> [Doc] -> [Doc]
punctuate _ []     = []
punctuate _ [d]    = [d]
punctuate p (d:ds) = (d <> p) : punctuate p ds

compact :: Doc -> String
compact doc = transform [doc]
  where
    transform [] = ""
    transform (d:ds) =
        case d of
            Empty      -> transform ds
            Char c     -> c : transform ds
            Text s     -> s ++ transform ds
            Line       -> '\n' : transform ds
            Concat a b -> transform (a:b:ds)