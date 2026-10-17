# hs2json

Biblioteca em Haskell para representação e serialização de dados JSON, com pretty printing e testes baseados em propriedades usando QuickCheck.

Projeto desenvolvido em dupla para a Avaliação da Unidade 2, no curso de Engenharia de Computação da Universidade Federal do Maranhão (UFMA), seguindo o tutorial da disciplina.

## Integrantes

- Jeysraelly Almone da Silva
- Cesar Roberto Ferreira Cardoso Filho

## Vídeo de apresentação

**Link: a adicionar após a gravação.**

## Organização e estrutura

O projeto utiliza Cabal para organizar a biblioteca, o executável de demonstração e a suíte de testes.

A estrutura atual, gerada pelo Cabal, é:

```text
hs2json/
├── hs2json.cabal
├── README.md
├── CHANGELOG.md
├── LICENSE
├── src/
│   └── MyLib.hs
├── app/
│   └── Main.hs
└── test/
    └── Spec.hs
```

- `src/`: código da biblioteca. O módulo inicial `MyLib` será substituído pelos módulos de representação e formatação de JSON.
- `app/Main.hs`: ponto de entrada do executável.
- `test/Spec.hs`: suíte de testes, que receberá as propriedades QuickCheck.
- `hs2json.cabal`: configuração dos componentes, módulos e dependências.

## Requisitos

- Git
- GHC
- cabal-install

Ambiente utilizado na configuração inicial:

| Ferramenta | Versão |
| --- | --- |
| GHC | 9.10.3 |
| cabal-install | 3.16.1.0 |

O projeto utiliza Haskell2010. A dependência QuickCheck será adicionada durante a implementação dos testes.

## Como executar

Clone o repositório:

```sh
git clone https://github.com/Jeys-almone/hs2json.git
cd hs2json
```

Compile o projeto:

```sh
cabal build
```

Execute o programa:

```sh
cabal run hs2json
```

Abra a biblioteca no interpretador:

```sh
cabal repl lib:hs2json
```

Execute a suíte de testes:

```sh
cabal test
```

Neste momento, o executável e a suíte de testes contêm os exemplos iniciais gerados pelo Cabal.

## Referência

[Construindo e Testando uma Biblioteca Haskell: JSON, Pretty Printing e QuickCheck](https://lambdageo-edu.github.io/lambdageo-tutorials/haskell/)

## Licença

Este projeto utiliza a licença [BSD-3-Clause](LICENSE).