#!/bin/sh
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1; export ORACLE_HOME
#ORACLE_SID=TSH1; export ORACLE_SID
ORACLE_SID=BDSOA01; export ORACLE_SID
ORACLE_TERM=xterm; export ORACLE_TERM
PATH=/usr/sbin:$PATH; export PATH
PATH=$ORACLE_HOME/bin:$PATH; export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jre:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
gosu oracle sqlplus /nolog <<EOF
connect / as sysdba
startup;
alter system disable restricted session;
EOF
#echo "alter system disable restricted session;" | sqlplus -s SYSTEM/test123
#echo "alter database character set internal_use  AL32UTF-8;" | sqlplus -s SYSTEM/test123
#echo "EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);" | sqlplus -s SYSTEM/test123

if [  -f $ORACLE_HOME/network/admin/init ];then

     gosu oracle lsnrctl start  
else 
     touch $ORACLE_HOME/network/admin/init
     gosu oracle netca /silent /responseFile /home/oracle/netca.rsp

fi

while :
do 
    sleep 600
done
