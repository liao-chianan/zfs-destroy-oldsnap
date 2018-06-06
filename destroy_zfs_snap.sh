outdays=31
poolname="zpool145/fileserver"
logfile="/root/backuplog/destroy_zfs_snap.log"

thistime=$(date +%s)
/sbin/zfs list -r -t snapshot -H -o name,creation $poolname  | \
while read line 
do
    createtime=$(echo $line |awk '{print $3,$4,$5,$6}' )
    createtimestamp=$(date --date="$createtime" +"%s")
    snapname=$(echo $line |awk '{print $1}' )
    createdays=$((($thistime - $createtimestamp)/86400))
        if (($createdays > $outdays)); then  
           echo "$snapname is out of date , destoroyah!!!!!" >> $logfile;  
           /sbin/zfs destroy $snapname
        fi;
done
