#!/bin/bash

case $1 in

	"-c"|"-certo") 
		echo -e ' \xE2\x9C\x94' "$2"
	;;

	"-i"|"-info")
		echo -e ' !' "$2"
	;;

	"-e"|"-errado")
		echo -e ' \xFE' "$2"
	;;

	"-t"|"-title")
		printf "\n###%2s \e[1m%-49s\e[0m \e[1m%-20s\e[0m \e[1m%-10s\e[0m\n\n" "" "$2" "$3" "$4"
	;;
	"-b"|"-bold")
		printf "\e[1m$2\e[0m\n"
	;;
	* ) 
		echo "$2"
	;;

esac

