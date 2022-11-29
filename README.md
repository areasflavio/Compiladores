# Compiladores

Trabalho desenvolvido como requisito parcial da disciplina ECOM06 - Compiladores,
do curso Engenharia da Computação na Universidade Federal de Itajubá.

O trabalho consiste na criação de um compilador para a linguagem especificada.
Implementação do Analisador Léxico e Sintático. Foram adicionados os arquivos
do Bison e foram feitas as integrações com o arquivo prévio do Flex.
Este projeto contém o analisador léxico em formato Flex e analisador sintático
em formato Bison com integração com o compilador G++.

## Instalação do Flex e Bison (LINUX)

```bash
sudo apt install flex bison
```

## Compilação e Execução do programa

**Remover arquivos temporários**

```bash
make clean
```

**Análise sintática e semântica**

```bash
make analise
```

**Compilação do programa .lft em cpp**

Nessa etapa será criado um arquivo (main.lex) contendo o reconhecimento de todos os TOKENS e um arquivo (main.cpp) com o código traduzido em C++ do programa compilado.

_É necessário passar o nome do arquivo de entrada no argumento file_

```bash
make compilar file=program.lft
```

**Execução do programa cpp gerado**

```bash
make executar
```

## Funções

- [x] Leitura de arquivo
- [x] Arquivos tokens de saída
- [x] Palavras reservadas
- [x] Identificadores (variáveis)
- [x] Números inteiros, reais, caracteres
- [x] Operadores aritméticos, lógicos, relacionais
- [x] Comando de atribuição
- [x] Input e Output
- [x] Declaração
- [x] Atribuição
- [x] Expressões Matemáticas
- [x] Expressões Lógicas
- [x] Condicionais (if/else)
- [x] Loops (for e while)
