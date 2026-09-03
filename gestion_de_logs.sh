#!/bin/bash
while true; do
    echo "================================="
    echo "     Gestión de Logs (Systemd)   "
    echo "================================="
    echo "1) Ver todos los logs del sistema"
    echo "2) Ver logs del arranque actual"
    echo "3) Ver solo errores"
    echo "4) Ver logs de un servicio específico"
    echo "5) Ver logs desde una fecha específica"
    echo "6) Ver logs de la última hora"
    echo "7) Salir"
    read -p "Seleccione una opción: " opcion

    case $opcion in
        1) journalctl ;;
        2) journalctl -b ;;
        3) journalctl -p err ;;
        4) 
            read -p "Ingrese el nombre del servicio (ej. nginx): " servicio
            journalctl -u "$servicio"
            ;;
        5) 
            read -p "Ingrese la fecha (ej. 2024-08-01): " fecha
            journalctl --since "$fecha"
            ;;
        6) journalctl --since "1 hour ago" ;;
        7) break ;;
        *) echo "Opción inválida. Intente de nuevo." ;;
    esac
    echo ""
done