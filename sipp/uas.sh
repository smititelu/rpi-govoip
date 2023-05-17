#!/bin/bash

#ulimit -Sn 55000

# UAS functions
uas_check() {
        # UAS params
	if [ $# -lt 1 ] || [ $# -gt 2 ]; then
		echo "Usage: ./uas.sh test_path_directory [optional_definesX_file]"
                echo "Eg:    ./uas.sh xml/reg/ 2"
                exit -1
        fi

        # UAS TEST PATH
        if ! [ -d "$1" ]; then
                echo "Error: $1 is not a directory!"
                echo "Usage: ./uas.sh test_path_directory [optional_definesX_file"
                echo "Eg:    ./uas.sh xml/reg/ 3"
                exit -1
        fi

	# UAS defines
	if [ $# -eq 2 ]; then
		source defines$2
	else
		source defines
	fi
}

uas_start() {
	# UAS vars
	DIR_TEST=$1

	# UAS call
	sipp	-aa -nd					\
		-r $MESSAGES_RATE			\
		-rp $MESSAGES_RATE_PERIOD		\
		-d $MESSAGES_PAUSE			\
		-m $MESSAGES				\
		-i $UAS_SIP_IP -p $UAS_SIP_PORT		\
		-mi $UAS_RTP_IP				\
		-min_rtp_port $UAS_RTP_PORT_MIN -max_rtp_port $UAS_RTP_PORT_MAX	\
		-sf "$DIR_TEST/$UAS_XML"		\
		-inf "$DIR_CSV/$UAS_CSV"		\
		-rtp_echo				\
		$SRV_SIP_IP:$SRV_SIP_PORT
}

uas_start_bg() {
	# UAS vars
	DIR_TEST=$1

	# UAS call
	sipp	-aa -nd					\
		-r $MESSAGES_RATE			\
		-rp $MESSAGES_RATE_PERIOD		\
		-d $MESSAGES_PAUSE			\
		-m $MESSAGES				\
		-i $UAS_SIP_IP -p $UAS_SIP_PORT		\
		-mi $UAS_RTP_IP				\
		-min_rtp_port $UAS_RTP_PORT_MIN -max_rtp_port $UAS_RTP_PORT_MAX	\
		-sf "$DIR_TEST/$UAS_XML"		\
		-inf "$DIR_CSV/$UAS_CSV"		\
		-rtp_echo				\
		$SRV_SIP_IP:$SRV_SIP_PORT &> /dev/null &
}

uas_check $@
uas_start $@
#uas_start_bg $@

exit $?
