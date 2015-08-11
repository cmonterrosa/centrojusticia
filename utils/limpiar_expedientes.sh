#!/bin/sh
###########################################################
### Script que limpia tablas de expedientes y sesiones ####
###########################################################

echo -n "=> Enter database name : "
read DATABASE
echo -n "=> Enter User : "
read USER
echo -n "=> Enter Password: "
read PASSWORD

tablas="
adjuntos
certificacions
cuadrantes
cuadrantes_users
users
roles_users
historias
horarios
invitacions
tramites
comparecencias
sesions
movimientos
concluidos
"

for tabla in ${tablas}
do
    echo "truncate ${tabla}" | mysql $DATABASE -u $USER -p$PASSWORD
done
echo "=> Finish"
