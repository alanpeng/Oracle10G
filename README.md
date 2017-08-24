It's oracle 10G  Dockerfile

Build the oracle images,for example:

Docker build -t oracle10 .

Run oracle docker images,for example:

docker run -itd --name oracle01 -p 1521:1521  oracle10g oracle10g

data persistence,for example 

docker run -itd --name oracle01 -p 1521:1521  -v myhome/data:/u04/oradata/ oracle10g oracle10g

Issue
1. you can't deploy the kernel paramter in oracle docker contianer,you must run  it with --privileged 
 
```
kernel.shmall = 2097152
kernel.shmmax = 2147483648
kernel.shmmni = 4096
# semaphores: semmsl, semmns, semopm, semmni
kernel.sem = 250 32000 100 128
fs.file-max = 65536
net.ipv4.ip_local_port_range = 1024 65000
net.core.rmem_default=262144
net.core.rmem_max=262144
net.core.wmem_default=262144
net.core.wmem_max=262144

```
2. ORA-27125: unable to create shared memory segment 

```
DBCA_PROGRESS : 4%
ORA-01034: ORACLE not available
ORA-01034: ORACLE not available
solution
# id oracle
uid=1000(oracle) gid=501(oinstall) groups=501(oinstall),502(dba)

echo 502 > /proc/sys/vm/hugetlb_shm_group

```
