#!/bin/bash
#
if grep -q Logged (gh auth status); then
	echo "tak"
else
	echo "nie"
fi

