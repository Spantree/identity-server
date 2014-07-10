#!/bin/bash -e


echo "who am i?  $(whoami)"


service slapd stop

slapadd -v -l ${1}

service slapd start
