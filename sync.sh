#!/bin/bash
# Vula course resource synchroniser
# Version 4.4
# Gianluca Truda
# 10 March 2017

# Fill in the details below

MAM="c48efc4a8-7cd8-4897-a873-227f1681d91e"
CSC="e14fc7a3-60ad-4e25-aed5-56050829b418"
MCB="af04b88e-c535-45f7-a592-eb654df0224e"
DIR="/Users/gianlucatruda/Documents/GIANLUCA/Current/resources"

#-------------------------------

DATE="`date '+%Y_%m_%d__%H_%M_%S'`"
TIMEOUTCOUNT=0
NETNAME=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`

function SYNC {

	echo
	echo $DATE
	echo
	echo Mounting Drives…
	osascript -e ' mount volume "https://vula.uct.ac.za/dav/'$MAM'" '
	osascript -e ' mount volume "https://vula.uct.ac.za/dav/'$CSC'" '
	osascript -e ' mount volume "https://vula.uct.ac.za/dav/'$MCB'" '
	cd /Users/gianlucatruda/Desktop
	echo Synchronising…
	rsync -avzh --progress //Volumes/$MAM/* $DIR/mam1005
	rsync -avzh --progress //Volumes/$CSC/* $DIR/csc2002
	rsync -avzh --progress //Volumes/$MCB/* $DIR/mcb2023
	echo Unmounting Drives…
	umount /Volumes/$MAM
	umount /Volumes/$CSC
	umount /Volumes/$MCB

	echo Sync Complete on $DATE
	echo
	echo _______________________________
	TIMEOUTCOUNT=0

}

function CHECK {
	wget -q --spider http://google.com

	if [ “$?” == “0” ]
	then
		echo
		echo Active network — $NETNAME
		SYNC
	elif [ “$?” != “0” ]
	then
		echo
		if [ $TIMEOUTCOUNT -lt 5 ]
		then
			((TIMEOUTCOUNT+=1))
			sleep 60
			echo Time Outs: $TIMEOUTCOUNT
			CHECK
		elif [ $TIMEOUTCOUNT -ge 5 ]
			then
			echo Network Down on $DATE
			echo _______________________________
		fi
	fi

}

CHECK
