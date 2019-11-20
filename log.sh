#!/bin/bash

case $1 in

	"-c") 
		echo -e "\xE2\x9C\x94" $2
	;;

	"-i")
		echo '!' $2
	;;

	"-e")
		echo -e "\xFE" $2
	;;

	* ) echo "Opção inválida!"

	;;

esac

