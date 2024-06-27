
# Syntax Analyzer

Syntax analysis part of a C compiler. yacc/bison is used as the parsing tool. It takes c code as input and generates a parse tree after parsing the input.

[Assignment Spec](https://github.com/TawhidMM/syntex_analyser/blob/master/materials/CSE310_July_2023_YACC_Assignment_Spec.pdf)

[yacc/bison materials](https://github.com/TawhidMM/syntex_analyser/tree/master/materials/book%26slide)


## Requirements

- **Flex :** a tool for tokenizing the input
- **yacc :** a tool for generating parser

## Installation
#### 1. update wsl/linux software packages
```bash
  sudo apt update
```
#### 2. install flex

```bash
  sudo apt install flex
```
#### 3. install yacc

```bash
  sudo apt install byacc
```

## How to run

#### 1. put the c code **input.txt**

#### 2. now run the command to generate output

```bash
  ./run.sh
```

## Related

The full CSE 310, BUET 
[Compiler](https://github.com/TawhidMM/C_Compiler)