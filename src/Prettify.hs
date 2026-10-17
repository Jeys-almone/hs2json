module Prettify
    ( Doc
    , empty
    , char
    , text
    , double
    , line
    , (<>)
    , hcat
    , fsep
    , (</>)
    , punctuate
    , group
    , softline
    , compact
    , pretty
    ) where

import Prelude hiding ((<>))

infixr 6 <>
infixr 5 </>

data Doc
    = Empty
    | Char Char
    | Text String
    | Line
    | Concat Doc Doc
    | Union Doc Doc
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

fsep :: [Doc] -> Doc
fsep = foldr (</>) empty

(</>) :: Doc -> Doc -> Doc
x </> y = x <> softline <> y

softline :: Doc
softline = group line

group :: Doc -> Doc
group doc = Union (flatten doc) doc

flatten :: Doc -> Doc
flatten (Concat a b) = Concat (flatten a) (flatten b)
flatten Line         = Char ' '
flatten (Union a _)  = flatten a
flatten other        = other

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
            Union _ b  -> transform (b:ds)

pretty :: Int -> Doc -> String
pretty width doc = best 0 [doc]
  where
    best _ [] = ""
    best col (d:ds) =
        case d of
            Empty      -> best col ds
            Char c     -> c : best (col + 1) ds
            Text s     -> s ++ best (col + length s) ds
            Line       -> '\n' : best 0 ds
            Concat a b -> best col (a:b:ds)
            Union a b  ->
                nicest col (best col (a:ds)) (best col (b:ds))

    nicest col a b
        | fits (width - min width col) a = a
        | otherwise                     = b

fits :: Int -> String -> Bool
fits width _ | width < 0 = False
fits _ ""               = True
fits _ ('\n':_)         = True
fits width (_:rest)     = fits (width - 1) rest