# hs2json

Biblioteca em Haskell para representação e serialização de dados JSON, com pretty printing e testes de propriedades previstos com QuickCheck.

Projeto desenvolvido em dupla para a Avaliação da Unidade 2, no curso de Engenharia de Computação da Universidade Federal do Maranhão (UFMA).

## Integrantes

- Jeysraelly Almone da Silva
- Cesar Roberto Ferreira Cardoso Filho

## Vídeo de apresentação

**Link: a adicionar após a gravação.**

## Sobre a biblioteca

Os dados JSON são representados pelo tipo `JValue`, que permite construir strings, números, booleanos, valores nulos, arrays e objetos aninhados.

O módulo `SimpleJSON` fornece as funções `getString`, `getInt`, `getDouble`, `getBool`, `getObject`, `getArray` e `isNull`. As funções de extração retornam `Just` quando o construtor corresponde ao tipo esperado e `Nothing` quando não corresponde. Conforme o tutorial, `getInt` descarta a parte fracionária do número.

A formatação utiliza o tipo abstrato `Doc`, definido em `Prettify`, com operações de composição, quebras de linha, escolha de layout conforme a largura e indentação com `nest`.

O módulo `PrettyJSON` trata escapes de strings e Unicode. Arrays e objetos não vazios são apresentados com quebras de linha fixas e dois espaços de indentação por nível.

## Organização e estrutura

```text
hs2json/
├── hs2json.cabal
├── README.md
├── CHANGELOG.md
├── LICENSE
├── src/
│   ├── SimpleJSON.hs
│   ├── PutJSON.hs
│   ├── Prettify.hs
│   └── PrettyJSON.hs
├── app/
│   └── Main.hs
└── test/
    └── Spec.hs
```

| Arquivo | Responsabilidade |
| --- | --- |
| `src/SimpleJSON.hs` | Tipo `JValue`, accessors e verificação de valor nulo. |
| `src/PutJSON.hs` | Renderização introdutória em texto, seguindo o tutorial. |
| `src/Prettify.hs` | Construção e renderização de documentos com controle de layout e indentação. |
| `src/PrettyJSON.hs` | Formatação JSON e tratamento de escapes. |
| `app/Main.hs` | Ponto de entrada do programa de demonstração. |
| `test/Spec.hs` | Suíte de testes. |
| `hs2json.cabal` | Configuração dos módulos, componentes e dependências. |

O `PutJSON` utiliza `show` nas strings e tem finalidade introdutória. Para o tratamento de escapes JSON implementado no projeto, utilize `PrettyJSON`.

## Requisitos

- Git
- GHC
- cabal-install

Ambiente utilizado:

| Ferramenta | Versão |
| --- | --- |
| GHC | 9.10.3 |
| cabal-install | 3.16.1.0 |

O projeto utiliza Haskell2010 e a especificação Cabal 3.0. A configuração atual depende de `base ^>=4.20.2.0`; outras versões de GHC ainda não foram verificadas.

## Como executar

Clone o repositório com `git clone https://github.com/Jeys-almone/hs2json.git` e entre na pasta com `cd hs2json`.

Na pasta do projeto, onde está o arquivo `hs2json.cabal`, execute:

- **Compilar o projeto:** `cabal build`
- **Executar a demonstração:** `cabal run hs2json`
- **Abrir a biblioteca no GHCi:** `cabal repl lib:hs2json`
- **Atualizar o índice de pacotes, quando necessário:** `cabal update`

Dentro do GHCi, use `:r` para recarregar os arquivos modificados e `:quit` para sair.


## Referência

[Construindo e Testando uma Biblioteca Haskell: JSON, Pretty Printing e QuickCheck](https://lambdageo-edu.github.io/lambdageo-tutorials/haskell/)

## Licença

Este projeto utiliza a licença [BSD-3-Clause](LICENSE).