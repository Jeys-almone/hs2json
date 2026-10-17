module PrettyJSON
    ( renderJValue
    ) where

import Prelude hiding ((<>))

import Data.Bits (shiftR, (.&.))
import Data.Char (ord)
import Numeric (showHex)

import SimpleJSON (JValue(..))
import Prettify (Doc, (<>), char, double, hcat, line, nest, text)

renderJValue :: JValue -> Doc
renderJValue (JString s)   = string s
renderJValue (JNumber n)   = double n
renderJValue (JBool True)  = text "true"
renderJValue (JBool False) = text "false"
renderJValue JNull         = text "null"
renderJValue (JArray a)    = series '[' ']' renderJValue a
renderJValue (JObject o)   = series '{' '}' field o
  where
    field (key, value) =
        string key <> text ": " <> renderJValue value

string :: String -> Doc
string = enclose '"' '"' . hcat . map oneChar

enclose :: Char -> Char -> Doc -> Doc
enclose left right doc = char left <> doc <> char right

oneChar :: Char -> Doc
oneChar c =
    case lookup c simpleEscapes of
        Just escaped -> text escaped
        Nothing
            | mustEscape c -> hexEscape c
            | otherwise    -> char c
  where
    mustEscape ch = ch < ' ' || ch == '\x7f' || ch > '\xff'

simpleEscapes :: [(Char, String)]
simpleEscapes =
    zipWith escape "\b\n\f\r\t\\\"/" "bnfrt\\\"/"
  where
    escape original escaped = (original, ['\\', escaped])

smallHex :: Int -> Doc
smallHex n =
    text "\\u"
        <> text (replicate (4 - length hexadecimal) '0')
        <> text hexadecimal
  where
    hexadecimal = showHex n ""

astral :: Int -> Doc
astral n =
    smallHex (high + 0xd800) <> smallHex (low + 0xdc00)
  where
    high = (n `shiftR` 10) .&. 0x3ff
    low  = n .&. 0x3ff

hexEscape :: Char -> Doc
hexEscape c
    | code < 0x10000 = smallHex code
    | otherwise     = astral (code - 0x10000)
  where
    code = ord c

series :: Char -> Char -> (a -> Doc) -> [a] -> Doc
series open close _ [] = char open <> char close
series open close item values =
    char open
        <> nest 2 (line <> separated (map item values))
        <> line
        <> char close

separated :: [Doc] -> Doc
separated []       = text ""
separated [doc]    = doc
separated (doc:ds) = doc <> char ',' <> line <> separated ds