#! /bin/sh
db=arbimon2
tables="jobs job_types job_queues"
prepop="job_types"
echo "Dumping $db structure"
mysqldump -p -d $db $tables | sed 's/ AUTO_INCREMENT=[0-9][0-9]*//' > $db-structure.sql
echo "Dumping $db prepopulated tables"
mysqldump -p -t --skip-extended-insert --skip-add-locks $db $prepop > $db-prepop-data.sql
