#!/bin/bash

./is_squid_active.sh
[ $? -ne 0 ] && ./log.sh -i "A correção da questão do Squid não poderá ser feita."
