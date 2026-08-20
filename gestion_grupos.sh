#!/bin/bash
opc=10
year=$(date +%Y-%m-%d)
function menu(){
	clear
	echo "========================================="
	echo "        MENÚ DE GESTIÓN DE GRUPOS        "
	echo "========================================="
	echo "1 - Agregar grupo"
	echo "2 - Borrar grupo"
	echo "3 - Listar grupos del sistema"
	echo "4 - Buscar un grupo en el sistema"
	echo "0 - Salir"
	echo "========================================="
}

function listar_grupos(){
	clear
	echo "========================================="
	echo "           GRUPOS DEL SISTEMA            "
	echo "========================================="
	cut -d ":" -f 1 /etc/group | sort | more
	echo "-----------------------------------------"
	echo "Presione enter para volver al menú principal"
	read pausa
}

function agregar_grupo(){
	clear
	read -p "Ingrese el nombre del grupo a agregar: " grupoUsuario
	grupo=$(echo "$grupoUsuario" | tr '[:upper:]' '[:lower:]')
	
	if getent group "$grupo" > /dev/null 2>&1; then
		echo "El grupo '$grupo' ya existe en el sistema."
	else
		groupadd "$grupo"
		if [ $? -eq 0 ]; then
			echo "Grupo '$grupo' agregado exitosamente."
			echo "$(date +%Y-%m-%d-%H:%M:%S) Grupo $grupo agregado por $USER" >> /root/log/log_propios/grupos.txt 2>/dev/null
		else
			echo "Error al agregar el grupo '$grupo'."
		fi
	fi
	echo "Presione enter para volver al menú principal"
	read pausa
}

function borrar_grupo(){
	clear
	read -p "Ingrese el nombre del grupo a borrar: " grupoUsuario
	grupo=$(echo "$grupoUsuario" | tr '[:upper:]' '[:lower:]')
	
	if getent group "$grupo" > /dev/null 2>&1; then
		groupdel "$grupo"
		if [ $? -eq 0 ]; then
			echo "Grupo '$grupo' borrado exitosamente."
			echo "$(date +%Y-%m-%d-%H:%M:%S) Grupo $grupo borrado por $USER" >> /root/log/log_propios/grupos.txt 2>/dev/null
		else
			echo "Error al borrar el grupo '$grupo'."
		fi
	else
		echo "El grupo '$grupo' no existe en el sistema."
	fi
	echo "Presione enter para volver al menú principal"
	read pausa
}

function buscar_grupo(){
	clear
	read -p "Ingrese el nombre del grupo a buscar: " grupoUsuario
	grupo=$(echo "$grupoUsuario" | tr '[:upper:]' '[:lower:]')
	
	if getent group "$grupo" > /dev/null 2>&1; then
		echo "El grupo '$grupo' EXISTE en el sistema."
	else
		echo "El grupo '$grupo' NO existe en el sistema."
	fi
	echo "Presione enter para volver al menú principal"
	read pausa
}

while [ $opc -ne 0 ]
do
	menu
	read -p "Ingrese la opción correspondiente: " opc
	case $opc in
	1)
		agregar_grupo ;;
	2)
		borrar_grupo ;;
	3)
		listar_grupos ;;
	4)
		buscar_grupo ;;
	0)
		echo "Saliendo del programa..."; break ;; 
	*)
		echo "Seleccionó una opción incorrecta."
		read pausa ;;
	esac
done
