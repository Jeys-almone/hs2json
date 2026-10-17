module PutJSON
    ( renderJValue
    , putJValue
    ) where

import Data.List (intercalate)
import SimpleJSON (JValue(..))

renderJValue :: JValue -> String
renderJValue (JString s)   = show s
renderJValue (JNumber n)   = show n
renderJValue (JBool True)  = "true"
renderJValue (JBool False) = "false"
renderJValue JNull         = "null"

renderJValue (JObject o) =
    "{" ++ intercalate ", " (map renderPair o) ++ "}"
  where
    renderPair (key, value) =
        show key ++ ": " ++ renderJValue value
renderJValue (JArray a) =
    "[" ++ intercalate ", " (map renderJValue a) ++ "]"

putJValue :: JValue -> IO ()
putJValue value = putStrLn (renderJValue value)