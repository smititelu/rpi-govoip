# rpi govoip
Overclocked raspberry pi 3 running raspbian buster with a U3 MicroSD card.

```
pi@raspberrypi:~ $ cat /etc/issue
Raspbian GNU/Linux 10 \n \l
```

```
pi@raspberrypi:~ $ uname -a
Linux pisip 5.4.51-v7+ #1327 SMP Thu Jul 23 10:58:46 BST 2020 armv7l GNU/Linux
```

```
pi@raspberrypi:~ $ cat /boot/config.txt
...
total_mem=1024
arm_freq=1300
core_freq=500
sdram_freq=500
sdram_schmoo=0x02000020
over_voltage=2
sdram_over_voltage=2
```


<br />
<br />



# rpi govoip repo
Add repo key:

```
wget -qO - https://repo.govoip.ro/repo.key | sudo apt-key add -
```

Add repo:

```
echo 'deb https://repo.govoip.ro buster main' | sudo tee --append /etc/apt/sources.list > /dev/null
```

Get repo:

```
sudo apt-get update

sudo apt-get install kamailio
sudo apt-get install ngcp-rtpengine
```


### 1. Kamailio
Built `.deb`s with all modules.

- kamailio 5.5.0 -> 5.5 branch at commit 97f9ede


### 2. RTPEngine
Built `.deb`s with all modules.

- rtpengine 9.5.0.0 -> master branch at commit 830abd6


### 3. bcg
Built `.deb`s with bcg lib.

- bcg 1.0.4


<br />
<br />


# rpi govoip test

### Test configuration
```
├── README.md
└── sipp
    ├── csv		-> SIPP configured users and passwords
    │   ├── uac.csv		-> ... for uac
    │   └── uas.csv		-> ... for uas
    ├── defines		-> SIPP configured parameters and IPs
    ├── uac.sh		-> script for running uac
    ├── uas.sh		-> script for running uas
    └── xml		-> SIPP xml scenarios
        ├── p2p			-> INVITE test without media xml
        │   ├── uac.xml			-> ... for uac
        │   └── uas.xml			-> ... for uas
        ├── p2p_rtp		-> INVITE test with RTP media xml
        │   ├── uac.xml			-> ... for uac
        │   └── uas.xml			-> ... for uas
        ├── p2p_srtp		-> INVITE test with SRTP media xml
        │   ├── uac.xml			-> ... for uac
        │   └── uas.xml			-> ... for uas
        └── reg			-> REGISTER test xml
            ├── uac.xml			-> ... for uac
            └── uas.xml			-> ... for uas
```


### Test run
##### 1. REGISTER test

```
./uas.sh xml/reg/
./uac.sh xml/reg/
```

```
              REGISTER
SIPP UAC/UAS  ------->  RPI Kamailio

               200 OK
SIPP UAC/UAS  <-------  RPI Kamailio
```


##### 2. INVITE test without media

```
./uas.sh xml/p2p/
./uac.sh xml/p2p/
```

```
           INVITE                 INVITE
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

           200 OK                 200 OK
SIPP UAC  <-------  RPI Kamailio <------- SIPP UAS

            ACK                    ACK
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

<-------------------- Pause --------------------->

            BYE                    BYE
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

           200 OK                 200 OK
SIPP UAC  <-------  RPI Kamailio <------- SIPP UAS
```


##### 3. INVITE test with RTP media (use SIPP from commit b2f7d2a onwards)

```
./uas.sh xml/p2p\_rtp/
./uac.sh xml/p2p\_rtp/
```

```
           INVITE                 INVITE
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

           200 OK                 200 OK
SIPP UAC  <-------  RPI Kamailio <------- SIPP UAS

            ACK                    ACK
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

<--------------------- RTP ---------------------->

            BYE                    BYE
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

           200 OK                 200 OK
SIPP UAC  <-------  RPI Kamailio <------- SIPP UAS
```


##### 4. INVITE test with SRTP media (use SIPP from commit b2f7d2a onwards)

```
./uas.sh xml/p2p\_srtp/
./uac.sh xml/p2p\_srtp/
```

```
   INVITE (crypto SDP)      INVITE (crypto SDP)
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

   200 OK (crypto SDP)      200 OK (crypto SDP)
SIPP UAC  <-------  RPI Kamailio <------- SIPP UAS

            ACK                    ACK
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

<------ SRTP (RTP with encrypted payload) ------->

            BYE                    BYE
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

           200 OK                 200 OK
SIPP UAC  <-------  RPI Kamailio <------- SIPP UAS
```
