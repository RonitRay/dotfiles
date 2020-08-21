#!/bin/bash

INT_PC="$(acpi|cut -d , -f2|cut -d % -f1)"
ST_C="$(acpi|grep -c 'Charging')"

if [ "$INT_PC" -gt 25 ]
then
        IND=""
else
        IND=" !!!"
fi

if [ "$ST_C" == "1" ]
then
        ICON="CHARGING:"
else
        ICON="BAT:"
fi


echo "$ICON$IND$INT_PC%"

