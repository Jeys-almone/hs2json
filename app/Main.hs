module Main (main) where

import SimpleJSON
    ( JValue(..)
    , getArray
    , getBool
    , getInt
    , getString
    , isNull
    )
import qualified PrettyJSON as JSON
import qualified Prettify as P

projeto :: JValue
projeto =
    JObject
        [ ("nome", JString "hs2json")
        , ("integrantes",
            JArray
                [ JString "Jeysraelly Almone"
                , JString "Cesar Roberto Ferreira Cardoso Filho"
                ])
        , ("avaliacao",
            JObject
                [ ("unidade", JNumber 2)
                , ("prazo", JString "21/10/2026")
                , ("em_dupla", JBool True)
                ])
        , ("observacao",
            JString "Apresentar \"hs2json\"\nDemonstrar biblioteca e testes.")
        , ("simbolo", JString "\x03bb")
        , ("link_video", JNull)
        ]

main :: IO ()
main = do
    putStrLn "=== hs2json: demonstracao da biblioteca ==="
    putStrLn ""
    putStrLn (P.pretty 80 (JSON.renderJValue projeto))

    putStrLn ""
    putStrLn "=== Extracao de valores com os accessors ==="

    putStrLn "Nome do projeto:"
    print (getString (JString "hs2json"))

    putStrLn "Unidade da avaliacao:"
    print (getInt (JNumber 2))

    putStrLn "Trabalho em dupla:"
    print (getBool (JBool True))

    putStrLn "Array de integrantes:"
    print (getArray (JArray [JString "Jeysraelly", JString "Cesar"]))

    putStrLn "Tentativa de extrair texto de um numero:"
    print (getString (JNumber 21))

    putStrLn "Link do video ainda nulo:"
    print (isNull JNull)