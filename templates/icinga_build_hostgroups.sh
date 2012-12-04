#!/bin/bash
backup_dir=/etc/icinga/backup/hostgroups
hostgroups_dir=<%= scope.lookupvar('icinga::target::customconfigdir') %>/hostgroups
hostgroups_build_dir=<%= scope.lookupvar('icinga::target::hostgroupsbuilddir') %>

[ -d $backup_dir ] || mkdir -p $backup_dir
mv $hostgroups_dir/* $backup_dir/

for hg in $(ls  $hostgroups_build_dir | cut -d ',' -f 1 | sort | uniq) ; do
  echo "# File generated by $0"     >  $hostgroups_dir/$hg.cfg 
  echo "define hostgroup {"         >> $hostgroups_dir/$hg.cfg 
  echo "    hostgroup_name $hg"     >> $hostgroups_dir/$hg.cfg 
  echo "    alias $hg"              >> $hostgroups_dir/$hg.cfg 
 
  for h in $(ls  $hostgroups_build_dir/${hg},* | cut -d ',' -f 2 | sort | uniq) ; do
    echo "    members $h,"          >> $hostgroups_dir/$hg.cfg 
  done

  echo "}"                          >> $hostgroups_dir/$hg.cfg 
done