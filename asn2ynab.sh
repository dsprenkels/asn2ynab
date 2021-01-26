#!/bin/bash

echo "Date,Payee,Category,Memo,Outflow,Inflow"
while IFS='' read -r line; do
	line=`echo "$line" | sed -e 's/\r//g'| tr -d \"`
	DATE=`echo "$line" | cut -d ';' -f 1` # ASN zet het al in DD-MM-YYYY | sed -e 's/\(\w\{4\}\)\(\w\{2\}\)\(\w\{2\}\)/\3\/\2\/\1/'`
	if [[ "$DATE" == "Datum" ]]; then
		continue
	fi
	#DATE=`echo "$line" | cut -d ';' -f 1`
	PAYEE=`echo "$line" | cut -d ';' -f 4 | tr 'a-z' 'A-Z'` # lowercase payee, convert to uppercase
	#CATEGORY
	AFBIJ=`echo "$line" | cut -d ';' -f 11`
	AMOUNT=`echo "$line" | cut -d ';' -f 11` # ASN heeft al puntnotatie
	TYPETRX=`echo "$line" | cut -d ';' -f 15`
	MEMO=`echo "$line" | cut -d ';' -f 18`

	INFLOW=""
	OUTFLOW=""

	if [[ "${AFBIJ:0:1}" == "-" ]]; then
		OUTFLOW="${AMOUNT#-}"
	elif [[ "${AFBIJ:0:1}" != "-" ]]; then
		INFLOW="$AMOUNT"
	fi

	if [[ "${PAYEE}x" == "x" ]]; then
		# Empty payee, we have to extract it from MEMO, and reset $PAYEE
		PAYEE=${MEMO%>*}
	fi

	echo ${DATE},\"${PAYEE}\",,\"${TYPETRX} / ${MEMO}\",${OUTFLOW},${INFLOW}
	#echo ${DATE},${PAYEE},,${TYPETRX} / ${MEMO},${OUTFLOW},${INFLOW}

done < "$1"
