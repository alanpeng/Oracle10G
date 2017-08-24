FROM centos
COPY oraInst.loc /etc/oraInst.loc 
COPY sysctl.conf /etc/sysctl.conf
COPY limits.conf /etc/security/limits.conf 
COPY login       /etc/pam.d/login 
COPY bash_profile /home/oracle/.bash_profile
COPY enterprise01.rsp /home/oracle/enterprise01.rsp
COPY dbca.rsp /home/oracle/dbca.rsp
COPY netca.rsp /home/oracle/netca.rsp
COPY gosu /usr/local/bin/gosu
COPY startup.sh /startup.sh
RUN yum install -y wget \
   && wget http://192.168.122.17:8080/oracle/10201_database_linux_x86_64.cpio \
   && cpio -idvm < 10201_database_linux_x86_64.cpio \
   && groupadd -g 501 oinstall \
   && groupadd -g 502 dba \
   && useradd -u 1000 -g oinstall -G dba oracle \
   && echo "oracle:test123" |chpasswd \
   && mkdir -p /u01/app/oracle/product/10.2.0/db_1 \
   && mkdir -p /u04/oradata/BDSOA01 \
   && chown oracle.oinstall -R /u04 \
   && chown -R oracle.oinstall /u01 \
   && chown -R oracle.oinstall /home/oracle \
   && chmod 775 /u01 \
   && chown oracle:oinstall /etc/oraInst.loc \
   && chmod 664 /etc/oraInst.loc \
   && yum -y install binutils compat-libstdc++-33 compat-libstdc++-33.i686 elfutils-libelf elfutils-libelf-devel gcc gcc-c++ \
      glibc glibc.i686 glibc-common glibc-devel glibc-devel.i686 glibc-headers ksh libaio libaio.i686 libaio-devel \
       libaio-devel.i686 libgcc libgcc.i686 libstdc++ libstdc++.i686 libstdc++-devel make sysstat libXp iproute libXp.i686 libXt.i686 libXtst.i686 \
   && chmod +x /usr/local/bin/gosu \
   && gosu oracle  /database/runInstaller -silent -responseFile /home/oracle/enterprise01.rsp \
   && sleep 180 \
   && /u01/app/oracle/product/10.2.0/db_1/root.sh \
   && gosu oracle /u01/app/oracle/product/10.2.0/db_1/bin/dbca -silent -responseFile /home/oracle/dbca.rsp \
   && rm -rf /database \
   && rm -rf  /10201_database_linux_x86_64.cpio	
EXPOSE 1521 8080
#VOLUME /u04/oradata/
CMD [ "/startup.sh" ]
