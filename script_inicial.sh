#!/bin/bash
opc=0

while [ "$opc" -ne 9 ]; do
    clear
    echo "=============================="
    echo "       MENU PRINCIPAL         "
    echo "=============================="
    echo "1 - Gestion de usuarios"
    echo "2 - Gestion de grupos"
    echo "3 - Gestion de respaldos"
    echo "4 - Gestion de redes"
    echo "5 - Gestion de Base de datos"
    echo "6 - Gestion de Firewall"
    echo "7 - Gestion de Logs del Sistema"
    echo "8 - Gestion de Docker"
    echo "9 - Salir"
    echo "=============================="
    read -p "Ingrese una opcion [1-9]: " opc

    case $opc in
        1) ./gestion_usuarios.sh ;;
        2) ./gestion_grupos.sh ;;
        3) ./menu_de_gestion_respaldos.sh ;;
        4) echo "Gestión de Redes" ;;
        5) echo "Gestión de Bases de Datos" ;;
        6) ./Script_Firewall.sh ;;
        7) echo "Gestión de Logs" ;;
        8) echo "Gestión de Docker" ;;
        9) echo "¡Hasta pronto!, buena jornada" ;;
        *) echo "Opción no soportada por el sistema" ;;
    esac

    if [ "$opc" -ne 9 ]; then
        echo ""
        read -p "Presione [Enter] para continuar..."
    fi
done
