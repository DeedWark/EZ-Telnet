#!/usr/bin/env bash
#Kenji DURIEZ - [DeedWark] 2020
#This script will perform TELNET in a sec

RED='\033[1;31m'
END='\033[0m'

read -r -p "SMTP server: " smtp
[[ -z "$smtp" ]] && echo -e "${RED}SMTP required!${END}" && exit 1
read -r -p "HELO/EHLO: " helo
read -r -p "MAIL FROM: " mfrom
read -r -p "RCPT TO: " rto
[[ -z "$rto" ]] && echo -e "${RED}RCPT TO required!${END}" && exit 1
read -r -p "From: " from
read -r -p "To: " to
read -r -p "Date (leave empty for current date): " date
read -r -p "Subject: " subject
read -r -p "Message-ID (leave empty for random or type 0 for none): " mid
read -r -p "Mailer (leave empty to put this one or type 0 for none): " xm
[[ -z "$from" ]] && from="$mfrom"
[[ -z "$to" ]] && to="$rto"
[[ -z "$date" ]] && curdate="$(date -R)"
[[ -z "$subject" ]] && subject=""
{ 
	echo "EHLO ${helo}";
	echo "MAIL FROM:<${mfrom}>";
	echo "RCPT TO:<${rto}>";
	echo "DATA";
	echo "Date: ${curdate}";
	echo "To: ${to}";
	echo "From: ${from}";
	echo "Subject: ${subject}";
	if [ -z "$mid" ]; then
		echo "Message-Id: <$(date "+%Y%m%d%H%M%S").$(shuf -i 1000-9999 -n 1)@$(hostname).thisdomain>" 
	elif [ "$mid" == "0" ]; then
		: 
	fi;
	if [ -z "$xm" ]; then 
		echo "X-Mailer: $(uname)"
	elif [ "$xm" == "0" ]; then
		: 
	fi;
	echo ".";
	sleep 1;
} | telnet ${smtp} 25
