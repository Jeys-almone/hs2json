{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Main (main) where

import Prelude hiding ((<>))
import Test.QuickCheck
import Data.List (intersperse)
import Control.Monad (liftM, liftM2)
import System.Exit (exitFailure)
import Prettify
import Data.Char (isSpace)


instance Arbitrary Doc where
    arbitrary = sized docTree
      where
        -- Folhas (n = 0): apenas nós terminais
        docTree 0 = frequency
            [ (1, return Empty)
            , (2, liftM Char arbitrary)
            , (2, liftM Text arbitrary)
            , (1, return Line)
            ]
        -- Nós internos: divide o tamanho n pela metade para evitar árvores gigantes
        docTree n = frequency
            [ (1, return Empty)
            , (2, liftM Char arbitrary)
            , (2, liftM Text arbitrary)
            , (1, return Line)
            , (3, liftM2 Concat (docTree (n `div` 2)) (docTree (n `div` 2)))
            , (2, liftM2 Union  (docTree (n `div` 2)) (docTree (n `div` 2)))
            ]

    shrink :: Doc -> [Doc]
    shrink = genericShrink

prop_empty_id :: Doc -> Bool
prop_empty_id x =
    empty <> x == x &&
    x <> empty == x


prop_char :: Char -> Bool
prop_char c = char c == Char c

prop_text :: String -> Bool
prop_text s = text s == if null s then Empty else Text s

prop_line :: Bool
prop_line = line == Line

prop_double :: Double -> Bool
prop_double d = double d == text (show d)


prop_hcat :: [Doc] -> Bool
prop_hcat xs = hcat xs == glue xs
  where
    glue []     = empty
    glue (d:ds) = d <> glue ds


prop_punctuate' :: Doc -> [Doc] -> Bool
prop_punctuate' s xs = punctuate s xs == combine (intersperse s xs)
  where
    combine []               = []
    combine [x]              = [x]
    combine (x : Empty : ys) = x : combine ys
    combine (Empty : y : ys) = y : combine ys
    combine (x : y : ys)     = x `Concat` y : combine ys


--pretty de documento simples não depende da largura w
prop_pretty_text :: Int -> String -> Property
prop_pretty_text w s = w > 0 ==> pretty w (text s) == s

--Toda linha gerada por pretty respeita a largura w, a menos que uma palavra exceda w
prop_pretty_fits :: NonNegative Int -> [String] -> Property
prop_pretty_fits (NonNegative w) rawWords = w > 0 ==>
    let -- Limpa quebras de linha dentro das palavras individuais
        cleanWords = filter (not . null) $ map (filter (\c -> c /= '\n' && c /= '\r')) rawWords
        doc        = fsep (map text cleanWords)
        outLines   = lines (pretty w doc)
        -- Uma linha estoura w apenas se contiver uma única palavra cujo tamanho já é > w
        fitsLine l = length l <= w || l `elem` cleanWords
    in all fitsLine outLines

--compact e pretty produzem o mesmo texto essencial em documentos formados pela API
--Para respeitar o invariante de Union (onde Union a b só é válido se a e b têm o mesmo conteúdo de texto),
--testamos a equivalência sobre árvores construídas com construtores e combinadores bem-formados
prop_compact_pretty_model :: NonNegative Int -> [String] -> Property
prop_compact_pretty_model (NonNegative w) wordsList = w > 0 ==>
    let doc = fsep (map text wordsList)
        normalize = filter (not . isSpace)
    in normalize (compact doc) == normalize (pretty w doc)

return []


runTests :: IO Bool
runTests = $quickCheckAll

main :: IO ()
main = do
    passed <- runTests
    if passed
        then putStrLn "Passou em todos os testes."
        else do
            putStrLn "Alguns testes falharam."
            exitFailure