#!/bin/bash
#
# DESCRIPTION
#    Capture and process a kill a watt lcd screen using ssocr and raspistill
#
# EXAMPLES
#    ${SCRIPT_NAME} -o DEFAULT arg1 arg2
#
#================================================================
#  HISTORY
#     2018/08/18 : tdailey : Initial Creation
#     2018/08/19 : tdailey : Add emoncms POST
#================================================================

function usage {

	cat <<EOM
Usage: $(basename "$0") [OPTION]...

  -r VALUE    rotation of camera angle in degrees
              154 default
  -c VALUE VALUE VALUE VALUE
	      crop input picture
              left right width height
  -e VALUE    emoncms http[s] endpoint
  -w VALUE    emoncms api write key
              DEFAULT: environment EMONAPIWRITE
  -d VALUE    emoncms api read key
              DEFAULT: environment EMONAPIREAD
  -h          display help
EOM
	exit 2
}

function cleanup {
	rm -f capture.jpg 2> /dev/null
	rm -f capture.txt 2> /dev/null
}

#initial values for arguments
rotate=154
crop="1000 900 600 200"
emoncms="http://$(hostname)"
emonwrite="$EMONAPIWRITE"
emonread="$EMONAPIREAD"

while getopts ":r:c:" o; do
    case "${o}" in
        r)
		rotate=${OPTARG}
		;;
	c)
		crop=${OPTARG}
		;;
        *)
		usage
		;;
    esac
done
shift $((OPTIND-1))

cleanup

echo "-----------------------------------------------------------"
echo "ssocr image processing parameters"
echo "-----------------------------------------------------------"
echo "rotate:  ${rotate}"
echo "crop:    ${crop}"
echo "-----------------------------------------------------------"
echo "emoncms parameters"
echo "-----------------------------------------------------------"
echo "emoncms : ${emoncms}"
echo "emoncms api write: ${emonwrite}"
echo "emoncms api read:  ${emonread}"

start_time="$(date -u +%s)"
raspistill -o capture.jpg

(set -x; ./ssocr/ssocr -v -d -1 -P -S -D -t 20 rotate ${rotate} crop ${crop} remove_isolated capture.jpg > capture.txt)
#(set -x; ./ssocr/ssocr -d -1 -S -t 20 rotate ${rotate} crop ${crop} remove_isolated capture.jpg > capture.txt)

end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"
capture_text=$(<capture.txt)

rm -f capture.jpg 2> /dev/null
rm -f capture.txt 2> /dev/null

echo "Took $elapsed seconds"
echo "$capture_text"

processed_val=""
while read -n1 character; do
	#count the number of dots in the string
	dots="${processed_val//[^\.]}"
	count_dot="${#dots}"

	#only save the first period in the string when
	#the string is non empty
	#the strings usually have some preceeding ....
	#which could be eroded but can cause digits to get corrupted
	if [ "$character" == "." ]; then
		if [ -n "$processed_val" ]; then
			if [ "$count_dot" =  "0" ]; then
				processed_val+=$character
			fi
		fi
	fi
	#this is not codefights
	#explicit parsing is easier to read
	if [ "$character" == "1" ]; then
		processed_val+=$character
	fi
	if [ "$character" == "2" ]; then
		processed_val+=$character
	fi
	if [ "$character" == "3" ]; then
		processed_val+=$character
	fi
	if [ "$character" == "4" ]; then
		processed_val+=$character
	fi
	if [ "$character" == "5" ]; then
		processed_val+=$character
	fi
	if [ "$character" == "6" ]; then
		processed_val+=$character
	fi
	if [ "$character" == "7" ]; then
		processed_val+=$character
	fi
	if [ "$character" == "8" ]; then
		processed_val+=$character
	fi
	if [ "$character" == "9" ]; then
		processed_val+=$character
	fi
	if [ "$character" == "0" ]; then
		processed_val+=$character
	fi

done < <(echo -n "$capture_text")

echo "Read $processed_val Watt"

(set -x; curl --data "node=$HOSTNAME&data={power1:$processed_val}&apikey=$emonwrite" "$emoncms/emoncms/input/post")
