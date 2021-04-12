#Diretorio do Backup
BKPDIR="/backups"

#Diretorio GLPI
GLPI_DIR="/var/www/html/glpi/"

#Periodo de retencao do backup em dias
RETENCAO=7

#DatabaseUSER
DATABASEUSER=glpi

#DatabePWD
DATABASEPASSWORD=xyz123

#DatabaseName
DATABASE=glpi


#Data
DATE=$(date +%d%m%Y_%H%M)

#====================================================
#Inicio do Backup DB
#====================================================
mysqldump -u $DATABASEUSER $(if [ $DATABASEPASSWORD != NULL ] ; then echo "-p$DATABASEPASSWORD"; fi) $DATABASE > $BKPDIR/glpi_db_$DATE.sql
tar -zvcf $BKPDIR/glpi_db_$DATE.tar.gz $BKPDIR/glpi_db_$DATE.sql
rm $BKPDIR/glpi_db_$DATE.sql

#===================================================
#Inicio Backup Pastas GLPI
#==================================================
tar -zvcf $BKPDIR/glpi_folders_$DATE.tar.gz $GLPI_DIR



# Validando se o DUMP foi bem sucedido

if [ $? -ne 0 ]
then
    # Caso o DUMP falhe, o script aborta a execucao
    echo "Erro ao executar Backup de $DATABASE"
    exit 1
else
    # Excluindo arquivos mais antigos que o periodo de retencao
    echo "Excluindo arquivos mais antigos!"
    find $BKPDIR/ -type f -mtime +$RETENCAO -exec rm -rf {} \;
fi
