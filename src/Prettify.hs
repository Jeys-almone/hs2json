module Prettify
    ( Doc(..)
    , empty
    , char
    , text
    , double
    , line
    , nest
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
    | Nest Int Doc
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

nest :: Int -> Doc -> Doc
nest amount doc = Nest (max 0 amount) doc

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
flatten (Concat a b)      = Concat (flatten a) (flatten b)
flatten Line              = Char ' '
flatten (Union a _)       = flatten a
flatten (Nest amount doc) = Nest amount (flatten doc)
flatten other             = other

punctuate :: Doc -> [Doc] -> [Doc]
punctuate _ []     = []
punctuate _ [d]    = [d]
punctuate p (d:ds) = (d <> p) : punctuate p ds

compact :: Doc -> String
compact doc = transform [(0, doc)]
  where
    transform [] = ""
    transform ((indent, d):ds) =
        case d of
            Empty ->
                transform ds
            Char c ->
                c : transform ds
            Text s ->
                s ++ transform ds
            Line ->
                '\n' : (replicate indent ' ' ++ transform ds)
            Concat a b ->
                transform ((indent, a):(indent, b):ds)
            Union _ b ->
                transform ((indent, b):ds)
            Nest amount nested ->
                transform ((indent + amount, nested):ds)

pretty :: Int -> Doc -> String
pretty width doc = best 0 [(0, doc)]
  where
    best _ [] = ""
    best col ((indent, d):ds) =
        case d of
            Empty ->
                best col ds
            Char c ->
                c : best (col + 1) ds
            Text s ->
                s ++ best (col + length s) ds
            Line ->
                '\n' : (replicate indent ' ' ++ best indent ds)
            Concat a b ->
                best col ((indent, a):(indent, b):ds)
            Union a b ->
                nicest col
                    (best col ((indent, a):ds))
                    (best col ((indent, b):ds))
            Nest amount nested ->
                best col ((indent + amount, nested):ds)

    nicest col a b
        | fits (width - min width col) a = a
        | otherwise                     = b

fits :: Int -> String -> Bool
fits width _ | width < 0 = False
fits _ ""               = True
fits _ ('\n':_)         = True
fits width (_:rest)     = fits (width - 1) rest