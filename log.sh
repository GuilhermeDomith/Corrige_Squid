#!/bin/bash

case $1 in

	"-c"|"-certo") 
		echo -e '\t \xE2\x9C\x94' "$2"
	;;

	"-i"|"-info")
		echo -e '\t !' "$2"
	;;

	"-e"|"-errado")
		echo -e '\t \xFE' "$2"
	;;

	"-t"|"-title")
		printf '\n###%2s \e[1m%s\e[0m \n\n' "" "$2"
	;;
	"-tt"|"-table-title")
		printf "\t%-2s \e[1m%-46s\e[0m \e[1m%s\e[0m\n" "" "$2" "$3"
	;;
	* ) echo "Opção inválida!"

	;;

esac

