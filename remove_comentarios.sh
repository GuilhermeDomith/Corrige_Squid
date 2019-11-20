#!/bin/bash

# 1-Remove linhas que começam com comententarios 
# 2-Apaga comentários que estão depois dos comandos
# 3-Remove linhas em branco 
sed -e /^s*#.*$/d $1 | sed 's/#.*$//' | sed '/^\s*$/d'

