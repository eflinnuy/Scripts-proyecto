#!/bin/bash
clear
while true; do
    echo "================================="
    echo "       Gestión de Docker         "
    echo "================================="
    echo "1) Ver contenedores en ejecución"
    echo "2) Ver imágenes locales"
    echo "3) Iniciar un contenedor"
    echo "4) Detener un contenedor"
    echo "5) Volver al menú principal"
    echo "================================="
    read -p "Seleccione una opción: " opcion

    case $opcion in
        1)
            docker ps
            echo ""
            read -p "Presione Enter para continuar..." enter
            clear
            ;;
        2)
            docker images
            echo ""
            read -p "Presione Enter para continuar..." enter
            clear
            ;;
        3)
            read -p "ID o nombre del contenedor: " cont
            docker start $cont
            echo ""
            read -p "Presione Enter para continuar..." enter
            clear
            ;;
        4)
            read -p "ID o nombre del contenedor: " cont
            docker stop $cont
            echo ""
            read -p "Presione Enter para continuar..." enter
            clear
            ;;
        5)
            break
            ;;
        *)
            echo "Opción inválida."
            read -p "Presione Enter para continuar..." enter
            clear
            ;;
    esac
done