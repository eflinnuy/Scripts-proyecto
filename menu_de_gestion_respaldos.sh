#!/bin/bash
# =========================================
# GESTIÓN DE RESPALDOS
# =========================================
# VARIABLES
opc=10
fecha=$(date +"%Y-%m-%d")
# CREAR CARPETAS
mkdir -p /root/respaldos_bd
mkdir -p /root/respaldos_logs
mkdir -p /root/logs_restaurados
# =========================================
# FUNCIONES
# =========================================
function menu(){
    clear
    echo "========================================="
    echo "       GESTIÓN DE RESPALDOS"
    echo "========================================="
    echo "1 - Crear respaldo de BD"
    echo "2 - Crear respaldo de Logs del sistema"
    echo "3 - Restaurar respaldo de BD"
    echo "4 - Restaurar respaldo de Logs del sistema"
    echo "5 - Eliminar respaldo"
    echo "6 - Listar respaldos disponibles"
    echo "7 - Configurar programación de respaldos"
    echo "8 - Enviar respaldo a ubicación remota"
    echo "0 - Salir"
    echo "========================================="
}
# =========================================
# CREAR RESPALDO DE BD
# =========================================
function crear_respaldo_bd(){
    clear
    echo "--- Creando respaldo de la base de datos ---"
    fecha=$(date +"%Y-%m-%d")
    mariadb-dump -u root -p \
    --databases sigsm \
    --routines \
    --triggers \
    --events \
    > "/root/respaldos_bd/$fecha-sigsm_bd_backup.sql"
    if [ $? -eq 0 ]; then
        echo "Respaldo de BD creado exitosamente."
    else
        rm -f "/root/respaldos_bd/$fecha-sigsm_bd_backup.sql"
        echo "Error: no se pudo crear el respaldo."
    fi
   read -p "Presione ENTER para continuar..." pausa
}
# =========================================
# CREAR RESPALDO DE LOGS
# =========================================
function crear_respaldo_logs(){
    clear
    echo "--- Creando respaldo de los logs del sistema ---"
    fecha=$(date +"%Y-%m-%d")
    tar -czvf \
    "/root/respaldos_logs/$fecha-logs_sistema_backup.tar.gz" \
    /var/log
    if [ $? -eq 0 ]; then
        echo "Respaldo de logs creado exitosamente."
    else
        echo "Error: no se pudo crear el respaldo."
    fi
    read -p "Presione ENTER para continuar..." pausa
}
# =========================================
# RESTAURAR RESPALDO DE BD
# =========================================
function restaurar_respaldo_bd(){
    clear
    echo "--- Restaurando respaldo de la base de datos ---"
    echo ""
    echo "Respaldos disponibles:"
    ls /root/respaldos_bd/
    echo ""
    read -p "Ingrese el nombre del archivo: " respaldo_bd
    mysql -u root -p < "/root/respaldos_bd/$respaldo_bd"
    if [ $? -eq 0 ]; then
        echo "Respaldo de BD restaurado exitosamente."
    else
        echo "Error: no se pudo restaurar el respaldo."
    fi
    read -p "Presione ENTER para continuar..." pausa
}
# =========================================
# RESTAURAR RESPALDO DE LOGS
# =========================================
function restaurar_respaldo_logs(){
    clear
    echo "--- Restaurando respaldo de los logs ---"
    echo ""
    echo "Respaldos disponibles:"
    ls /root/respaldos_logs/
    echo ""
    read -p "Ingrese el nombre del archivo: " respaldo_logs
    tar -xzvf \
    "/root/respaldos_logs/$respaldo_logs" \
    -C /root/logs_restaurados
    if [ $? -eq 0 ]; then
        echo "Respaldo de logs restaurado exitosamente."
    else
        echo "Error: no se pudo restaurar el respaldo."

    fi
    read -p "Presione ENTER para continuar..." pausa
}
# =========================================
# ELIMINAR RESPALDO
# =========================================
function eliminar_respaldo(){
    clear
    echo "--- Eliminar respaldo ---"
    echo ""
    echo "1 - Eliminar respaldo de BD"
    echo "2 - Eliminar respaldo de Logs"
    echo ""
    read -p "Seleccione una opción: " tipo
    if [ "$tipo" -eq 1 ]; then
        echo ""
        echo "Respaldos de BD:"
        ls /root/respaldos_bd/
        echo ""
        read -p "Ingrese el nombre del respaldo: " archivo
        rm "/root/respaldos_bd/$archivo"
        echo "Respaldo eliminado."
    elif [ "$tipo" -eq 2 ]; then
        echo ""
        echo "Respaldos de Logs:"
        ls /root/respaldos_logs/
        echo ""
        read -p "Ingrese el nombre del respaldo: " archivo
        rm "/root/respaldos_logs/$archivo"
        echo "Respaldo eliminado."
    else
        echo "Opción incorrecta."
    fi
    read -p "Presione ENTER para continuar..." pausa
}
# =========================================
# LISTAR RESPALDOS
# =========================================
function listar_respaldos(){
    clear
    echo "--- RESPALDOS DE BD ---"
    ls -lh /root/respaldos_bd/
    echo ""
    echo "--- RESPALDOS DE LOGS ---"
    ls -lh /root/respaldos_logs/
    echo ""
    read -p "Presione ENTER para continuar..." pausa
}
# =========================================
# CONFIGURAR CRONTAB
# =========================================
function configurar_programacion_respaldos(){
    clear
    echo "--- CONFIGURACIÓN DE RESPALDOS AUTOMÁTICOS ---"
    echo ""
    echo "1 - Backup de BD todos los días a las 02:00"
    echo "2 - Backup de Logs todos los días a las 03:00"
    echo "3 - Backup de BD y Logs automáticamente"
    echo "4 - Ver programación actual"
    echo "5 - Editar Crontab manualmente"
    echo "6 - Eliminar programación de respaldos"
    echo "0 - Volver"
    echo ""
    read -p "Seleccione una opción: " programacion
    case $programacion in
        1)
            crontab -l 2>/dev/null | grep -v "RESPALDO_SIGSM" > /tmp/crontab_backup
            echo "# RESPALDO_SIGSM" >> /tmp/crontab_backup
            echo "0 2 * * * /root/menu_de_gestion_respaldos.sh 1" >> /tmp/crontab_backup
            crontab /tmp/crontab_backup
            rm -f /tmp/crontab_backup
            echo ""
            echo "Backup automático de BD configurado."
            echo "Se ejecutará todos los días a las 02:00."
            ;;
        2)
            crontab -l 2>/dev/null | grep -v "RESPALDO_SIGSM" > /tmp/crontab_backup
            echo "# RESPALDO_SIGSM" >> /tmp/crontab_backup
            echo "0 3 * * * /root/menu_de_gestion_respaldos.sh 2" >> /tmp/crontab_backup
            crontab /tmp/crontab_backup
            rm -f /tmp/crontab_backup
            echo ""
            echo "Backup automático de Logs configurado."
            echo "Se ejecutará todos los días a las 03:00."
            ;;
        3)
            crontab -l 2>/dev/null | grep -v "RESPALDO_SIGSM" > /tmp/crontab_backup
            echo "# RESPALDO_SIGSM" >> /tmp/crontab_backup
            echo "0 2 * * * /root/menu_de_gestion_respaldos.sh 1" >> /tmp/crontab_backup
            echo "0 3 * * * /root/menu_de_gestion_respaldos.sh 2" >> /tmp/crontab_backup
            crontab /tmp/crontab_backup
            rm -f /tmp/crontab_backup
            echo ""
            echo "Programación configurada correctamente."
            echo ""
            echo "BD:   todos los días a las 02:00"
            echo "Logs: todos los días a las 03:00"
            ;;
        4)
            echo ""
            echo "--- PROGRAMACIÓN ACTUAL ---"
            echo ""
            crontab -l
            ;;
        5)
            crontab -e
            ;;
        6)
            crontab -l 2>/dev/null | grep -v "RESPALDO_SIGSM" > /tmp/crontab_backup
            crontab /tmp/crontab_backup
            rm -f /tmp/crontab_backup
            echo ""
            echo "Programación de respaldos eliminada."
            ;;
        0)
            return
            ;;
        *)
            echo ""
            echo "Opción incorrecta."
            ;;
    esac
    echo ""
    read -p "Presione ENTER para continuar..." pausa
}
# =========================================
# ENVIAR RESPALDO A SERVIDOR REMOTO
# =========================================
function enviar_respaldo_remoto(){
    clear
    echo "--- Enviar respaldo a ubicación remota ---"
    echo ""
    read -p "Ingrese usuario remoto: " usuario
    read -p "Ingrese IP del servidor: " ip
    read -p "Ingrese archivo a enviar: " archivo
    scp "$archivo" "$usuario@$ip:/root/"
    if [ $? -eq 0 ]; then
        echo ""
        echo "Respaldo enviado correctamente."
    else
        echo ""
        echo "Error: no se pudo enviar el respaldo."
    fi
    read -p "Presione ENTER para continuar..." pausa
}
# =========================================
# EJECUCIÓN AUTOMÁTICA DE CRON
# =========================================
# CRON 1 = RESPALDO DE BD
if [ "$1" = "1" ]; then
    fecha=$(date +"%Y-%m-%d")
    mariadb-dump -u root \
    --databases sigsm \
    --routines \
    --triggers \
    --events \
    > "/root/respaldos_bd/$fecha-sigsm_bd_backup.sql"
    exit 0
fi
# CRON 2 = RESPALDO DE LOGS
if [ "$1" = "2" ]; then
    fecha=$(date +"%Y-%m-%d")
    tar -czf \
    "/root/respaldos_logs/$fecha-logs_sistema_backup.tar.gz" \
    /var/log
    exit 0
fi
# =========================================
# MAIN
# =========================================
while [ $opc -ne 0 ]
do
    menu
    read -p "Ingrese la opción: " opc
    case $opc in
        1)
            crear_respaldo_bd
            ;;
        2)
            crear_respaldo_logs
            ;;
        3)
            restaurar_respaldo_bd
            ;;
        4)
            restaurar_respaldo_logs
            ;;
        5)
            eliminar_respaldo
            ;;
        6)
            listar_respaldos
            ;;
        7)
            configurar_programacion_respaldos
            ;;
        8)
            enviar_respaldo_remoto
            ;;
        0)
            clear
            echo "Saliendo del programa..."
            break
            ;;
        *)
            echo "Opción incorrecta."
            read -p "Presione ENTER para continuar..." pausa
            ;;
    esac
done
