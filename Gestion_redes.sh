#!/bin/bash

# VARIABLES
opc=10
fecha=$(date +"%Y-%m-%d_%H-%M-%S")

# CREAR CARPETAS PARA REPORTES
mkdir -p /root/reportes_red

# FUNCIONES

function menu(){
    clear
    echo "========================================="
    echo "         HERRAMIENTAS DE RED            "
    echo "========================================="
    echo "1 - Ver mis redes y direcciones"
    echo "2 - Probar conexión con otro equipo"
    echo "3 - Ver qué programas usan internet"
    echo "4 - Buscar dirección de una página"
    echo "5 - Ver el camino que siguen los datos"
    echo "6 - Revisar puertos abiertos"
    echo "7 - Ver dispositivos conectados cerca"
    echo "8 - Guardar un informe completo de red"
    echo "0 - Salir"
    echo "========================================="
}

function ver_interfaces(){
    clear
    echo "--- Estado de interfaces y direcciones IP ---"
    
    ip -c a
    
    echo
    read -p "Presione ENTER para continuar..." pausa
}

function probar_conectividad(){
    clear
    echo "--- Prueba de conectividad (Ping) ---"
    
    read -p "Ingrese la IP o dominio a testear: " destino
    read -p "Ingrese cantidad de paquetes (ej. 4): " paquetes
    
    ping -c "$paquetes" "$destino"
    
    read -p "Presione ENTER para continuar..." pausa
}

function ver_conexiones(){
    clear
    echo "--- Conexiones de red activas y puertos ---"
    
    if command -v ss &> /dev/null; then
        ss -tulpn
    else
        netstat -tulpn
    fi

    echo
    read -p "Presione ENTER para continuar..." pausa
}

function consulta_dns(){
    clear
    echo "--- Consulta DNS ---"
    
    read -p "Ingrese el dominio o IP a consultar: " objetivo
    
    if command -v nslookup &> /dev/null; then
        nslookup "$objetivo"
    else
        host "$objetivo"
    fi

    echo
    read -p "Presione ENTER para continuar..." pausa
}

function rastrear_ruta(){
    clear
    echo "--- Rastrear ruta (Traceroute) ---"
    
    read -p "Ingrese el destino (IP o dominio): " destino
    
    if command -v traceroute &> /dev/null; then
        traceroute "$destino"
    else
        tracepath "$destino"
    fi

    echo
    read -p "Presione ENTER para continuar..." pausa
}

function escanear_puertos(){
    clear
    echo "--- Escaneo rápido de puertos ---"
    
    read -p "Ingrese la IP o dominio a escanear: " objetivo
    
    if command -v nmap &> /dev/null; then
        nmap -F "$objetivo"
    else
        echo "Aviso: 'nmap' no está instalado. Usando nc (netcat) para puerto rápido..."
        read -p "Ingrese el puerto a verificar: " puerto
        nc -zv "$objetivo" "$puerto"
    fi

    echo
    read -p "Presione ENTER para continuar..." pausa
}

function ver_tabla_arp(){
    clear
    echo "--- Tabla ARP y vecinos de red ---"
    
    ip neigh
    
    echo
    read -p "Presione ENTER para continuar..." pausa
}

function guardar_reporte_red(){
    clear
    echo "--- Generando reporte completo de red ---"
    
    archivo_reporte="/root/reportes_red/$fecha-reporte_red.txt"
    
    {
        echo "========================================="
        echo " REPORTE DE RED - $fecha"
        echo "========================================="
        echo "--- INTERFACES ---"
        ip a
        echo -e "\n--- TABLA DE RUTAS ---"
        ip route
        echo -e "\n--- CONEXIONES ACTIVAS ---"
        ss -tulpn
        echo -e "\n--- TABLA ARP ---"
        ip neigh
    } > "$archivo_reporte"

    if [ $? -eq 0 ]; then
        echo "Reporte guardado exitosamente en: $archivo_reporte"
    else
        echo "Error: no se pudo generar el reporte."
    fi

    read -p "Presione ENTER para continuar..." pausa
}

# MAIN

while [ $opc -ne 0 ]
do

    menu

    read -p "Ingrese la opción: " opc

    case $opc in

        1)
            ver_interfaces
            ;;

        2)
            probar_conectividad
            ;;

        3)
            ver_conexiones
            ;;

        4)
            consulta_dns
            ;;

        5)
            rastrear_ruta
            ;;

        6)
            escanear_puertos
            ;;

        7)
            ver_tabla_arp
            ;;

        8)
            guardar_reporte_red
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
