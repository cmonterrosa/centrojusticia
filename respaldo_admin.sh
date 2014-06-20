#!/bin/bash
###################################################
### Script que respalda tablas administrativas ####
###################################################
user=root
database=ceja_tuxtla
tablas=(
     'configuracions estatus'
     'estatus_roles'
     'estatus_sesions' 
     'horarios' 
     'justificacions' 
     'salas'
     'flujos'
     'roles'
     'roles_users'
     'situacions' 
     'subdireccions' 
     'users')
echo "mysqldump $database ${tablas[*]} -u $user -p> dump.sql" | sh
