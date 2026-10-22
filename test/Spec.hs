{-# LANGUAGE TemplateHaskell #-}

module Main (main) where

import Prelude hiding ((<>))
import Test.QuickCheck
import Data.List (intersperse)
import Control.Monad (liftM, liftM2)
import System.Exit (exitFailure)
import Prettify

instance Arbitrary Doc where
    arbitrary =
        oneof [ return Empty
              , liftM  Char   arbitrary
              , liftM  Text   arbitrary
              , return Line
              , liftM2 Concat arbitrary arbitrary
              , liftM2 Union  arbitrary arbitrary ]

prop_empty_id :: Doc -> Bool
prop_empty_id x =
    empty <> x == x &&
    x <> empty == x

return []
runTests = $quickCheckAll

main :: IO ()
main = do
    passed <- runTests
    if passed
        then putStrLn "Passou em todos os testes."
        else do
            putStrLn "Alguns testes falharam."
            exitFailure