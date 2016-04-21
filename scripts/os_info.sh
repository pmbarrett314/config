#!/bin/sh
# Detects which OS and if it is Linux then it will detect which Linux
# Distribution.
# http://linuxmafia.com/faq/Admin/release-files.html

OS=`uname -s`
REV=`uname -r`
MACH=`uname -m`

GetVersionFromFile()
{
	VERSION=`cat $1 | tr "\n" ' ' | sed s/.*VERSION.*=\ // `
}

if [ "${OS}" = "SunOS" ] ; then
	OS=Solaris
	ARCH=`uname -p`	
	OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
elif [ "${OS}" = "AIX" ] ; then
	OSSTR="${OS} `oslevel` (`oslevel -r`)"
elif [ "${OS}" = "Linux" ] ; then
	KERNEL=`uname -r`
	if [ -f /etc/redhat-release ] ; then
		DIST='RedHat'
		PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
		REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
	elif [ -f /etc/SuSE-release ] ; then
		DIST=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
		REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
	elif [ -f /etc/mandrake-release ] ; then
		DIST='Mandrake'
		PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
		REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
	elif [ -f /etc/debian_version ] ; then	
		if [ `awk -F= '/DISTRIB_ID/ {print $2}' /etc/lsb-release` = "Ubuntu" ]; then
			DIST="Ubuntu"
		else
			DIST="Debian `cat /etc/debian_version`"
			REV=""
		fi
	elif [ -f /etc/arch-release ] ; then
		DIST="Arch"
	fi
	if [ -f /etc/UnitedLinux-release ] ; then
		DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
	fi
	
	OSSTR="${OS} ${DIST} ${REV}(${PSUEDONAME} ${KERNEL} ${MACH})"

fi

get_distro() {
	echo ${DIST}
}