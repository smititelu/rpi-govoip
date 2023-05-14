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

- kamailio 5.4.0


### 2. RTPEngine
Built `.deb`s with all modules.

- rtpengine 9.0.0.0


### 3. bcg
Built `.deb`s with bcg lib.

- bcg 1.0.4


<br />
<br />


# rpi govoip test
Add following sipp tests:


### 1. REGISTER test
```
              REGISTER
SIPP UAC/UAS  ------->  RPI Kamailio

               200 OK
SIPP UAC/UAS  <-------  RPI Kamailio
```


### 2. INVITE test

```
           INVITE                 INVITE
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

           200 OK                 200 OK
SIPP UAC  <-------  RPI Kamailio <------- SIPP UAS

            ACK                    ACK
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS




            BYE                    BYE
SIPP UAC  ------->  RPI Kamailio -------> SIPP UAS

           200 OK                 200 OK
SIPP UAC  <-------  RPI Kamailio <------- SIPP UAS
```
