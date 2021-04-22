#!/bin/bash

# Authors:
# 	- Gerdriaan Mulder <mrngm@moeilijklastig.nl> (2020)
#   - Daan Sprenkels <daan@dsprenkels.com> (2021)
#
# This script is based on the original asn2ynab.sh script from Gerdriaan
# Mulder, from whom I have a license to modify and redistribute future
# versions with attribution.

echo "Date,Payee,Category,Memo,Outflow,Inflow"
while IFS='' read -r line; do
	line=$(echo "$line" | sed -e 's/\r//g'| tr -d \")

	# ASN export already uses DD-MM-YYYY, so no need to convert.
	DATE=$(echo "$line" | cut -d ';' -f 1)
	if [[ "$DATE" == "Datum" ]]; then
		# This line contains the CSV headers, skip.
		continue
	fi
	PAYEE=$(echo "$line" | cut -d ';' -f 4 | tr '[:lower:]' '[:upper:]') # lowercase payee, convert to uppercase
	AFBIJ=$(echo "$line" | cut -d ';' -f 11)
	AMOUNT=$(echo "$line" | cut -d ';' -f 11) # ASN already has dot separator; no need to convert.
	TX_TYPE=$(echo "$line" | cut -d ';' -f 15)
	MEMO=$(echo "$line" | cut -d ';' -f 18)

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

	echo "${DATE},\"${PAYEE}\",,\"${TX_TYPE} / ${MEMO}\",${OUTFLOW},${INFLOW}"

done < "$1"
