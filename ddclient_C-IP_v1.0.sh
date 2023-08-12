#!/bin/bash
#
# name          : ddclient_C-IP
# desciption    : ddclient WANIP compare and updatescript
# autor         : Speefak ( itoss@gmx.de )
# licence       : (CC) BY-NC-SA by speefak
# version	: 1.0
#
#------------------------------------------------------------------------------------------------------------
############################################################################################################
#######################################   define global variables   ########################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------

HostAddress1=host1
HostAddress2=
HostAddress3=

WANIP=$(wget -q -O - http://www.nwlab.net/cgi-bin/show-ip-js | cut -d'>' -f2 | cut -d '<' -f 1 | sed -ne '2p')  
#WANIP=$(wget -q -O - https://check.torproject.org | grep "Your IP address appears to be:" | cut -d ">" -f2 | cut -d "<" -f1)		# HTTPS yes			# HTTPS no
#WANIP=$(wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//')						# HTTPS no
#ActualIP=$(nslookup $DDNSADDR | tr -d ':' | cut -f5 | grep Address | cut -c9-23) 
#ActualIP=$(nslookup $DDNSADDR | awk 'NR == 5' | awk -F" " '{print $2}')

#------------------------------------------------------------------------------------------------------------
############################################################################################################
###########################################   define functions   ###########################################
############################################################################################################
#-------------------------------------------------------------------------------------------------------------------------------------------------------

gethostip () {
	ActualIP=$(nslookup $DDNSADDR | tr -d ':' | cut -f5 | grep Address | cut -c9-23) 
}

function comparse_ips ()
{
	if   [ "$WANIP" == "$ActualIP" ] ; then
		echo
		echo "$WANIP => actual WAN IP"
		echo "$ActualIP => $DDNSADDR IP"
		echo
		echo " IP not changed - Do nothing ... "

	else
		echo
		echo "$WANIP => actual WAN IP"
		echo "$ActualIP => $DDNSADDR IP"
		echo
		echo " IP CHANGED AND NOT UPDATED TO $DDNSADDR"
		echo
		echo "starting ddnclient"
		echo
		echo "IP changed on $(date) from $ActualIP to $WANIP" | mail -s "IP CHANGE  for  => $DDNSADDR <=  to $WANIP" root
		sudo /usr/sbin/./ddclient --force
	fi
}

#####################
## Starting Script ##
#####################

DDNSADDR=$HostAddress1
gethostip
comparse_ips

DDNSADDR=$HostAddress2
gethostip
comparse_ips

#DDNSADDR=$HostAddress3
#gethostip
#comparse_ips

