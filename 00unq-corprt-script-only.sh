#!/bin/sh

DIR="$( cd "$( dirname "$0" )" && pwd )"

# Set the date of today as the default date parameter.
# If run with a commandline arguement like 1 or any number,
# today will be replaced by that day. Like 1 for yesterday,
# 2 for the day before yesterday and so on.
# ---------------------------------------------------------
default='0'
arg="${1:-$default}"
cdate=`date -d "$(date +%Y-%m-%d) -$arg day" +%Y%m%d`
msgdt=`date -d "$(date +%Y-%m-%d) -$arg day" +%A,%d-%B,%Y`

today=`date -d "$(date +%Y-%m-%d) -$arg day" +%Y-%m-%d`
TODAY=`date -d "$(date +%Y-%m-%d) -$arg day" +%Y_%m_%d`
TODAY_2=`date -d "$(date +%Y-%m-%d) -$arg day" +%d%m%y`
MONTH=`date -d "$(date +%Y-%m-%d) -$arg day" +%Y_%m`

today="`date +%Y-%m-%d`"

a1=$"_unique_rejection"
a2=$".txt"
unique_rejection="$DIR/$cdate$a1$a2"

b1=$"_corporate_porting"
b2=$".txt"
corporate="$DIR/$cdate$b1$b2"

sqlplus READONLY/cMHW22Ev2mWLxE3G@172.17.200.22:1521/mnp.mnp.local<<EOFMYSQL

spool "$unique_rejection"

select
        (CASE WHEN rec.operatorcode = 81 THEN 'ROBI' WHEN rec.operatorcode = 51 THEN 'Teletalk' WHEN rec.operatorcode = 71 THEN 'GP' WHEN rec.operatorcode = 91 THEN 'BL' ELSE 'Unknown' END) as "RECEPIENT"
       ,(CASE WHEN DON.operatorcode = 81 THEN 'ROBI' WHEN DON.operatorcode = 51 THEN 'Teletalk' WHEN DON.operatorcode = 71 THEN 'GP' WHEN DON.operatorcode = 91 THEN 'BL' ELSE 'Unknown' END) as "DONOR"
       ,count(distinct td.msisdnnumber) as UNIQUE_REJECTION
FROM MNP.TODO TD
JOIN MNP.OPERATOR DON ON TD.DONOR_ID = DON.ID
JOIN MNP.OPERATOR REC ON TD.RECIPIENT_ID = REC.ID
where
--TO_CHAR(TD.CREATED, 'MON-YYYY')='MAR-2019' and
TRUNC(TD.CREATED)= TRUNC(SYSTIMESTAMP - $arg)
and TRUNC(TD.CREATED)= TRUNC(SYSTIMESTAMP - $arg)
--TO_CHAR(TD.CREATED, 'MON-YYYY')='MAR-2019' and
and TD.STATE = 'REJECTED'
and td.msisdnnumber not in (select msisdnnumber from MNP.HISTORY where TRUNC(CREATED)= TRUNC(SYSTIMESTAMP - $arg) and TRUNC(CREATED)= TRUNC(SYSTIMESTAMP - $arg) )
group by  rec.operatorcode,DON.operatorcode
order by rec.operatorcode,DON.operatorcode;
spool off;

EOFMYSQL
