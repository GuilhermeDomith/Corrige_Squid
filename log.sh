#!/bin/bash

case $1 in

	"-c") 
		echo -e '\t \xE2\x9C\x94' "$2"
	;;

	"-i")
		echo -e '\t !' "$2"
	;;

	"-e")
		echo -e '\t \xFE' "$2"
	;;

	"-t")
		printf '\n###%2s %s\n\n' "" "$2"
	;;

	* ) echo "Opção inválida!"

	;;

esac

