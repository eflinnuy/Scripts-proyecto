#!/bin/bash

# VARIABLES
opc=10
fecha=$(date +"%Y-%m-%d")

# CREAR CARPETAS
mkdir -p /root/respaldos_bd
mkdir -p /root/respaldos_logs
mkdir -p /root/logs_restaurados

# FUNCIONES

function menu(){
    clear
    echo "========================================="
    echo "       GESTIÓN DE RESPALDOS              "
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

function crear_respaldo_bd(){
    clear
    echo "--- Creando respaldo de la base de datos ---"

    mariadb-dump -u root -p --databases sigsm --routines --triggers --events > "$fecha-sigsm_bd_backup.sql"

    if [ $? -eq 0 ]; then
        mv "$fecha-sigsm_bd_backup.sql" /root/respaldos_bd/
        echo "Respaldo de BD creado exitosamente."
    else
        rm -f "$fecha-sigsm_bd_backup.sql"
        echo "Error: no se pudo crear el respaldo."
    fi

    read -p "Presione ENTER para continuar..." pausa
}

function crear_respaldo_logs(){
    clear
    echo "--- Creando respaldo de los logs del sistema ---"

    tar -czvf "$fecha-logs_sistema_backup.tar.gz" /var/log

    mv "$fecha-logs_sistema_backup.tar.gz" /root/respaldos_logs/

    echo "Respaldo de logs creado exitosamente."
    read -p "Presione ENTER para continuar..." pausa
}

function restaurar_respaldo_bd(){
    clear
    echo "--- Restaurando respaldo de la base de datos ---"

    echo "Respaldos disponibles:"
    ls /root/respaldos_bd/

    read -p "Ingrese el nombre del archivo: " respaldo_bd

    mysql -u root -p < "/root/respaldos_bd/$respaldo_bd"

    echo "Respaldo de BD restaurado exitosamente."
    read -p "Presione ENTER para continuar..." pausa
}

function restaurar_respaldo_logs(){
    clear
    echo "--- Restaurando respaldo de los logs ---"

    echo "Respaldos disponibles:"
    ls /root/respaldos_logs/

    read -p "Ingrese el nombre del archivo: " respaldo_logs

    tar -xzvf "/root/respaldos_logs/$respaldo_logs" -C /root/logs_restaurados

    echo "Respaldo de logs restaurado exitosamente."
    read -p "Presione ENTER para continuar..." pausa
}

function eliminar_respaldo(){
    clear
    echo "--- Eliminar respaldo ---"

    echo "1 - Eliminar respaldo de BD"
    echo "2 - Eliminar respaldo de Logs"

    read -p "Seleccione una opción: " tipo

    if [ "$tipo" -eq 1 ]; then

        ls /root/respaldos_bd/
        read -p "Ingrese el nombre del respaldo: " archivo

        rm "/root/respaldos_bd/$archivo"

        echo "Respaldo eliminado."

    elif [ "$tipo" -eq 2 ]; then

        ls /root/respaldos_logs/
        read -p "Ingrese el nombre del respaldo: " archivo

        rm "/root/respaldos_logs/$archivo"

        echo "Respaldo eliminado."

    else

        echo "Opción incorrecta."

    fi

    read -p "Presione ENTER para continuar..." pausa
}

function listar_respaldos(){
    clear

    echo "--- RESPALDOS DE BD ---"
    ls -lh /root/respaldos_bd/

    echo
    echo "--- RESPALDOS DE LOGS ---"
    ls -lh /root/respaldos_logs/

    read -p "Presione ENTER para continuar..." pausa
}

function configurar_programacion_respaldos(){
    clear
    echo "--- Configurando programación de respaldos ---"

    crontab -e

    read -p "Presione ENTER para continuar..." pausa
}

function enviar_respaldo_remoto(){
    clear
    echo "--- Enviar respaldo a ubicación remota ---"

    read -p "Ingrese usuario remoto: " usuario
    read -p "Ingrese IP del servidor: " ip
    read -p "Ingrese archivo a enviar: " archivo

    scp "$archivo" "$usuario@$ip:/root/"

    echo "Respaldo enviado."
    read -p "Presione ENTER para continuar..." pausa
}

# MAIN

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
