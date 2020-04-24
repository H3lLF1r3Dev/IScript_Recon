#!/bin/bash
# Version: 1.0.0
# Track change last updated by: X_FOR_ON3 - junho 2019 (v0.0.10)

SCRIPT=`basename ${BASH_SOURCE[0]}`

#Variables definition
OPT_F=png
com=cutycapt
prot=http
check=1

#Set fonts for Help.
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`

#Help function
function HELP {
  echo -e \\n"Help documentation for ${BOLD}${SCRIPT}.${NORM}"\\n
  echo -e "${REV}Basic usage:${NORM} ${BOLD}$SCRIPT -i exemple.com -o exemple${NORM}"\\n
  echo "${REV}-i${NORM}  --Sets the value for a single ${BOLD}ip${NORM}. e.g. http://192.168.0.1:8080 or http://192.168.0.1"
  echo "${REV}-p${NORM}  --Sets the value for port ${BOLD}ip${NORM}. e.g. 8080 or 8080,8008"
  echo "${REV}-l${NORM}  --Sets the value for a list of ${BOLD}ips${NORM}. e.g. ./Desktop/test/list"
  echo "${REV}-o${NORM}  --Sets the value for output ${BOLD}dir${NORM}. e.g. ./Desktop/output"
  echo "${REV}-f${NORM}  --Sets the value for format ${BOLD}d${NORM}. Default is ${BOLD}png${NORM}. Formats accepted are png|pdf|ps|svg|jpeg"
  echo -e "${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
  exit 1
}

if [ -z $1 ]
then
HELP
exit 2
fi
while getopts :i:l:p:o:f:h FLAG; do
  case $FLAG in
    i)
      OPT_I=$OPTARG
      url=$OPT_I
      ;;
    l)
	url=`cat $OPTARG`
      ;;
    p)
      OPT_P=$OPTARG
      IFS=', ' read -r -a array <<< "$OPT_P"
      check=2
     ;;
    o)
      OPT_O=$OPTARG
      check=3 
     ;;
    f)
      OPT_F=$OPTARG
      ;;
    h)  #show help
      HELP
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      ;;
  esac
done
shift $((OPTIND-1))
 
	function PRINT {
	for x in $url; do
		target=`echo $x | sed 's/^http:\/\///' | sed 's/^https:\/\///'`
		echo "Capturing $target"
		$com --insecure --delay=10000 --url=$x --out=$target.$OPT_F >/dev/null 2>&1
		wget $x --dns-timeout=10 --connect-timeout=20 --force-html -o $target.txt
		mkdir /root/Desktop/PRINTS_SITES
		mv *.png index.* $target.txt /root/Desktop/PRINTS_SITES/ >/dev/null 2>&1
	done
exit 1
}
	function PRINT2 {
        for element in "${array[@]}"; do
		target=$(echo "$url:$element")
		echo "Capturing $target"
        	$com --insecure --delay=10000 --url=$target --out=$target.$OPT_F >/dev/null 2>&1
                wget $target --dns-timeout=10 --connect-timeout=20 --force-html --output-file=$target.txt
		mkdir /root/Desktop/PRINTS_SITES
		mv *.png index.* $target.txt /root/Desktop/PRINTS_SITES/ >/dev/null 2>&1
	done
exit 1
}

	function PRINT3 {
        for element in "${array[@]}"; do
        	target=$(echo "$url:$element")
        	echo "Capturing $target"
		$com --insecure --delay=10000 --url=$target --out=$OPT_O.$OPT_F >/dev/null 2>&1
		wget $target --dns-timeout=10 --connect-timeout=20 --force-html --output-file=$target.txt
		mkdir /root/Desktop/PRINTS_SITES
		mv *.png index.* $target.txt /root/Desktop/PRINTS_SITES/ >/dev/null 2>&1
        done
exit 1
}

	function MAIN {
	case $check in
         1)
 		PRINT
	 ;;
	 2) 
		PRINT2
	 ;;
	 3)
		PRINT3
	 ;;
esac
}


MAIN
