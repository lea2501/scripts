#!/bin/ksh

# 'kern.maxproc' default value is 1310
sysctl kern.maxproc=8192
echo "kern.maxproc=8192" >> /etc/sysctl.conf

# 'kern.maxfiles' default value is 7030
sysctl kern.maxfiles=32768
echo "kern.maxfiles=32768" >> /etc/sysctl.conf

# 'kern.maxthread' default value is 1950
sysctl kern.maxthread=16384
echo "kern.maxthread=16384" >> /etc/sysctl.conf

# 'kern.shminfo.shmmax' default value is 33554432
sysctl kern.shminfo.shmmax=2147483647
echo "kern.shminfo.shmmax=2147483647" >> /etc/sysctl.conf

# 'kern.shminfo.shmall' default value is 8192
sysctl kern.shminfo.shmall=5242880
echo "kern.shminfo.shmall=5242880" >> /etc/sysctl.conf

# 'kern.shminfo.shm' default value is 1024
sysctl kern.shminfo.shmmni=4096
echo "kern.shminfo.shmmni=4096" >> /etc/sysctl.conf
