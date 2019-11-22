#!/bin/bash

# 1-Remove linhas que começam com comententarios 
# 2-Apaga comentários que estão depois dos comandos
# 3-Remove linhas em branco 
# 4-Remove espaços em branco para apenas 1 espaço
sed -e /^s*#.*$/d $1 | sed 's/#.*$//' | sed '/^\s*$/d' | sed -e  's/ \{1,\}/ /g' | sed -e 's/ $//g'

