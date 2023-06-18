# RPI
Overclocked raspberry pi 4 running raspbian buster with a Sandisk U1 MicroSD card.

```
pi@raspberrypi:~ $ cat /etc/issue
Raspbian GNU/Linux 11 \n \l
```

```
pi@raspberrypi:~ $ uname -a
Linux pisip.govoip.ro 6.1.21-v7l+ #1639 SMP Fri Mar 24 16:59:30 GMT 2023 armv7l GNU/Linux
```

<br />
<br />

# RPI repo
Add repo key:

```
wget -qO - https://repo.govoip.ro/repo.key | sudo apt-key add -
```

Add repo:

```
echo 'deb https://repo.govoip.ro bullseye main' | sudo tee --append /etc/apt/sources.list > /dev/null
```

Get repo:

```
sudo apt-get update

sudo apt-get install kamailio
sudo apt-get install ngcp-rtpengine
```


### 1. Kamailio `.deb`s
- kamailio 5.7.0 -> 5.7 branch at commit 1c23c2f


### 2. RTPEngine `.deb`s
- rtpengine 11.4.0.0 -> master branch at commit 3760c8d


### 3. OpenSIPs `.deb`s
- opensips 3.4.0 -> 3.4 branch at commit deeefa7


<br />
<br />


# RPI test

### Test configuration
```
.
├── README.md
└── sipp
    ├── csv		-> SIPP configured users and passwords
    │   ├── uac.csv
    │   └── uas.csv
    ├── defines		-> SIPP configured parameters and IPs
    ├── defines1
    ├── defines2
    ├── defines3
    ├── defines4
    ├── uac.sh		-> script for running uac
    ├── uas.sh		-> script for running uas
    └── xml		-> SIPP xml sceanrios
        ├── p2p			-> INVITE test without RTP
        │   ├── uac.xml
        │   └── uas.xml
        ├── p2p_rtp		-> INVITE test with RTP
        │   ├── long.pcap
        │   ├── uac.xml
        │   └── uas.xml
        ├── p2p_rtp_reinvite	-> INVITE test with RTP and RE-INVITE with RTP
        │   ├── long.pcap
        │   ├── uac.xml
        │   └── uas.xml
        ├── p2p_srtp		-> INVITE test with SRTP
        │   ├── uac.xml
        │   └── uas.xml
        ├── reg			-> REGISTER test
        │   ├── uac.xml
        │   └── uas.xml
        └── sub			-> SUBSCRIBE/NOTIFY test
            └── uac.xml
```


### Test run
```
./uas.sh xml/reg/
./uac.sh xml/reg/
...
./uas.sh xml/p2p_srtp/
./uac.sh xml/p2p_srtp/
...
./uac.sh xml/sub/
...
```

<br />

##### 1. REGISTER test
```
              REGISTER
SIPP UAC/UAS  ------->  RPI SIP SERVER

               200 OK
SIPP UAC/UAS  <-------  RPI SIP SERVER
```

<br />

##### 2. INVITE test without media
```
           INVITE                   INVITE
SIPP UAC  ------->  RPI SIP SERVER -------> SIPP UAS

           200 OK                   200 OK
SIPP UAC  <-------  RPI SIP SERVER <------- SIPP UAS

            ACK                      ACK
SIPP UAC  ------->  RPI SIP SERVER -------> SIPP UAS

<-------------------- Pause --------------------->

            BYE                      BYE
SIPP UAC  ------->  RPI SIP SERVER -------> SIPP UAS

           200 OK                   200 OK
SIPP UAC  <-------  RPI SIP SERVER <------- SIPP UAS
```

<br />

##### 3. INVITE test with RTP media
```
Same as 2. but with RTP instead of Pause
```

<br />

##### 4. INVITE test with SRTP media (use SIPP from commit b2f7d2a onwards)
```
Same as 2. but with SRTP instead of Pause
```

<br />

##### 5. RE-INVITE test with RTP media
```
Same as 2. but with RTP instead of Pause and Re-INVITE updates UAC RTP port.
RTP media continues to be sent after RE-INVITE on new UAC port
```

<br />

##### 6. SUBSCRIBE/NOTIFY test
```
          SUBSCRIBE
SIPP UAC  -------->  RPI SIP SERVER
           200 OK
SIPP UAC  <--------  RPI SIP SERVER
           NOTIFY
SIPP UAC  <--------  RPI SIP SERVER
           200 OK
SIPP UAC  -------->  RPI SIP SERVER
```
