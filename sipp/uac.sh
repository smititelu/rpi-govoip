#!/bin/bash

#ulimit -Sn 55000

# UAC functions
uac_check() {
	# UAC params
	if [ $# -lt 1 ] || [ $# -gt 2 ]; then
		echo "Usage: ./uac.sh test_path_directory [optional_definesX_file]"
		echo "Eg:    ./uac.sh xml/reg/"
		echo "Eg:    ./uac.sh xml/reg/ 2"
		exit -1
	fi

	# UAC TEST PATH
	if ! [ -d "$1" ]; then
		echo "Error: $1 is not a directory!"
		echo "Usage: ./uac.sh test_path_directory [optional_definesX_file]"
		echo "Eg:    ./uac.sh xml/reg/ 3"
		exit -1
	fi

	# UAC defines
	if [ $# -eq 2 ]; then
		source defines$2
	else
		source defines
	fi
}

uac_start() {
	# UAC vars
	DIR_TEST=$1

	# UAC call
	sipp 	-nd -aa					\
		-r $MESSAGES_RATE			\
		-rp $MESSAGES_RATE_PERIOD		\
		-d $MESSAGES_PAUSE			\
		-m $MESSAGES				\
		-i $UAC_SIP_IP -p $UAC_SIP_PORT		\
		-mi $UAC_RTP_IP                         \
		-min_rtp_port $UAC_RTP_PORT_MIN -max_rtp_port $UAC_RTP_PORT_MAX \
		-sf "$DIR_TEST/$UAC_XML"		\
		-inf "$DIR_CSV/$UAC_CSV"		\
		-inf "$DIR_CSV/$UAS_CSV"		\
		-key custom_event message-summary	\
		$SRV_SIP_IP:$SRV_SIP_PORT
}

uac_start_bg() {
	# UAC vars
	DIR_TEST=$1

	# UAC call
	sipp 	-nd -aa					\
		-r $MESSAGES_RATE			\
		-rp $MESSAGES_RATE_PERIOD		\
		-d $MESSAGES_PAUSE			\
		-m $MESSAGES				\
		-i $UAC_SIP_IP -p $UAC_SIP_PORT		\
		-mi $UAC_RTP_IP                         \
		-min_rtp_port $UAC_RTP_PORT_MIN -max_rtp_port $UAC_RTP_PORT_MAX \
		-sf "$DIR_TEST/$UAC_XML"		\
		-inf "$DIR_CSV/$UAC_CSV"		\
		-inf "$DIR_CSV/$UAS_CSV"		\
		-key custom_event message-summary	\
		$SRV_SIP_IP:$SRV_SIP_PORT &> /dev/null &
}

uac_check $@
uac_start $@
#uac_start_bg $@

exit $?
