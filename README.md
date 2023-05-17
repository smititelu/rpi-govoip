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
- kamailio 5.7.0 -> 5.7 branch at commit a651304


### 2. RTPEngine `.deb`s
- rtpengine 11.4.0.0 -> master branch at commit 13a7e1d


### 3. bcg `.deb`s
- bcg 1.0.4


### 4. OpenSIPS `.deb`s
- opensips 3.3.5-1 -> 3.3 branch at commit b0465ca


<br />
<br />


# RPI test

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
        ├── reg			-> REGISTER test xml
        │   ├── uac.xml			-> ... for uac
        │   └── uas.xml			-> ... for uas
        └── sub			-> SUBSCRIBE test xml
            └── uac.xml			-> ... for uac
```


### Test run
```
./uas.sh xml/reg/
./uac.sh xml/reg/
...
./uas.sh xml/p2p_srtp/
./uac.sh xml/p2p_srtp/
...
./uas.sh xml/sub/
./uac.sh xml/sub/
...
```

<br />

##### 1. REGISTER test
```
              REGISTER
SIPP UAC/UAS  ------->  RPI Kamailio

               200 OK
SIPP UAC/UAS  <-------  RPI Kamailio
```

<br />

##### 2. INVITE test without media
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

<br />

##### 3. INVITE test with RTP media (use SIPP from commit b2f7d2a onwards)
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

<br />

##### 4. INVITE test with SRTP media (use SIPP from commit b2f7d2a onwards)
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

<br />

##### 5. SUBSCRIBE/NOTIFY test
```
         SUBSCRIBE
SIPP UAC  ------->  RPI Kamailio
           200 OK
SIPP UAC  <-------  RPI Kamailio
           NOTIFY
SIPP UAC  <-------  RPI Kamailio
           200 OK
SIPP UAC  ------->  RPI Kamailio
```
