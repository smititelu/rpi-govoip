#!/bin/bash

source defines

# UAS functions
uas_check() {
        # UAS params
        if ! [ $# -eq 1 ]; then
                echo "Usage: ./uas.sh [test_path_directory]"
                echo "Eg:    ./uas.sh xml/reg/"
                exit -1
        fi

        # UAS TEST PATH
        if ! [ -d "$1" ]; then
                echo "Error: $1 is not a directory!"
                echo "Usage: ./uas.sh [test_path_directory]"
                echo "Eg:    ./uas.sh xml/reg/"
                exit -1
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
		-mi $UAS_RTP_IP -mp $UAS_RTP_PORT	\
		-sf "$DIR_TEST/$UAS_XML"		\
		-inf "$DIR_CSV/$UAS_CSV"		\
		-key "uas_pcap" "$DIR_PCAP/$UAS_PCAP"   \
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
		-mi $UAS_RTP_IP -mp $UAS_RTP_PORT	\
		-sf "$DIR_TEST/$UAS_XML"		\
		-inf "$DIR_CSV/$UAS_CSV"		\
		-key "uas_pcap" "$DIR_PCAP/$UAS_PCAP"   \
		$SRV_SIP_IP:$SRV_SIP_PORT &> /dev/null &
}

uas_check $@
uas_start $@
#uas_start_bg $@

exit $?
