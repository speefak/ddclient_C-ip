#!/bin/bash
#
# name          : ddclient_C-IP
# desciption    : ddclient WANIP compare and updatescript
# autor         : Speefak ( itoss@gmx.de )
# licence       : (CC) BY-NC-SA by speefak
# version	: 1.1
#
#------------------------------------------------------------------------------------------------------------
############################################################################################################
#######################################   define global variables   ########################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------

 HostAddress1=host1
#HostAddress2=
#HostAddress3=

 WANIP=$(wget -q -O - http://www.nwlab.net/cgi-bin/show-ip-js | cut -d'>' -f2 | cut -d '<' -f 1 | sed -ne '2p') 
 
#WANIP=$(wget -q -O - https://check.torproject.org | grep "Your IP address appears to be:" | cut -d ">" -f2 | cut -d "<" -f1)		# HTTPS yes			# HTTPS no
#WANIP=$(wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//')						# HTTPS no

#------------------------------------------------------------------------------------------------------------
############################################################################################################
###########################################   define functions   ###########################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------
gethostip () {
	ActualIP=$(nslookup $DynDnsAddress | tr -d ':' | cut -f5 | grep Address | cut -c9-23) 
}
#------------------------------------------------------------------------------------------------------------
comparse_ips () {
	if   [ "$WANIP" == "$ActualIP" ] ; then
		echo
		echo "$WANIP => actual WAN IP"
		echo "$ActualIP => $DynDnsAddress IP"
		echo
		echo " IP not changed - Do nothing ... "

	else
		echo
		echo "$WANIP => actual WAN IP"
		echo "$ActualIP => $DynDnsAddress IP"
		echo
		echo " IP CHANGED AND NOT UPDATED TO $DynDnsAddress"
		echo
		echo "starting ddnclient"
		echo
		echo "IP changed on $(date) from $ActualIP to $WANIP ($HOSTNAME)" | mail -s "IP CHANGE for  => $DynDnsAddress <=  to $WANIP ($HOSTNAME)" root
		sudo /usr/sbin/./ddclient --force
	fi
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------
############################################################################################################
#############################################   start script   #############################################
############################################################################################################
#------------------------------------------------------------------------------------------------------------

 for HostAddress in $(cat $0 | grep "HostAddress[[:digit:]]" | grep -v "^#") ; do
	DynDnsAddress=$( cut -d "=" -f2-10 <<< "$HostAddress")
	gethostip
	comparse_ips
 done

#------------------------------------------------------------------------------------------------------------

exit 0

