#!/bin/bash
while true; do
    echo "================================="
    echo "  Gestión de Bases de Datos      "
    echo "================================="
    echo "1) Ver estado del servicio MySQL"
    echo "2) Iniciar servicio MySQL"
    echo "3) Detener servicio MySQL"
    echo "4) Volver al menú principal"
    read -p "Seleccione una opción: " opcion

    case $opcion in
        1) systemctl status mysql --no-pager ;;
        2) sudo systemctl start mysql; echo "Servicio iniciado." ;;
        3) sudo systemctl stop mysql; echo "Servicio detenido." ;;
        4) break ;;
        *) echo "Opción inválida. Intente de nuevo." ;;
    esac
    echo ""
done