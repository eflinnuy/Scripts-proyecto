#!/bin/bash
opc=10
year=$(date +%Y-%m-%d)

function menu(){
	clear
	echo "========================================="
	echo "        MENÚ DE GESTIÓN DE USUARIOS       "
	echo "========================================="
	echo "1 - Agregar usuario"
	echo "2 - Borrar usuario"
	echo "3 - Listar usuarios del sistema"
	echo "4 - Buscar un usuario en el sistema"
	echo "5 - Cambiar contraseña de un usuario"
	echo "6 - Bloquear usuario"
	echo "7 - Desbloquear usuario"
	echo "0 - Salir"
	echo "========================================="
}

function agregar_usuario(){
	clear
	# Nomenclatura del usuario apellidonombre
	echo "Ingrese el apellido y nombre del usuario en formato (apellidonombre): "
	read nombre
	usuario=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')
	
	# Verificar existencia exacta del usuario en /etc/passwd
	grep -q "^${usuario}:" /etc/passwd
	if [ $? -eq 0 ]; then
		echo "El usuario '$usuario' ya existe."
		echo "El usuario $USER en la fecha $(date +%Y-%m-%d-%H:%M:%S) trato de crear un usuario con el nombre $usuario pero ya existe." >> /root/log/log_propios/usuarios.txt
		read pausa
	else
		echo "Ingrese el grupo: "
		read grupo
		user_group=$(echo "$grupo" | tr '[:upper:]' '[:lower:]')
		
		# Verificar existencia exacta del grupo
		grep -q "^${user_group}:" /etc/group
		if [ $? -eq 0 ]; then
			useradd -g "$user_group" -c "$user_group $year" -m -k /etc/skel -s /bin/bash "$usuario"
			echo "$usuario:12345" | chpasswd
			echo "El usuario $USER en la fecha $(date +%Y-%m-%d-%H:%M:%S) agrego el usuario $usuario perteneciente al grupo $user_group al sistema" >> /root/log/log_propios/usuarios.txt
			echo "Usuario '$usuario' dado de alta correctamente con contraseña por defecto '12345'."
			read pausa
		else
			echo "El grupo '$user_group' no existe en el sistema."
			echo "$(date +%Y-%m-%d-%H:%M:%S) Se trato de asignar el grupo $user_group pero no existe." >> /root/log/log_propios/grupos.txt
			read pausa
		fi
	fi
}

function borrar_usuario(){
	clear
	echo "Ingrese el apellido y nombre del usuario a eliminar (apellidonombre): "
	read nombre
	usuario=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')
	
	grep -q "^${usuario}:" /etc/passwd
	if [ $? -eq 0 ]; then
		echo -n "El usuario $usuario será eliminado del sistema. ¿Está seguro? [S/N]: "
		read respuesta
		if [ "$respuesta" == "S" ] || [ "$respuesta" == "s" ]; then
			userdel -r "$usuario" 2>/dev/null
			echo "Usuario '$usuario' eliminado del sistema. Presione Enter para continuar."
			echo "$(date +%Y-%m-%d-%H:%M:%S) Usuario: $usuario eliminado del sistema por $USER" >> /root/log/log_propios/usuarios.txt
			read pausa
		else
			echo "Operación cancelada. Presione Enter para volver al menú."
			read pausa
		fi
	else
		echo "El usuario '$usuario' no existe. Presione Enter para volver al menú."
		read pausa
	fi   
}

function listar_usuarios(){
	clear
	echo "========================================="
	echo "          USUARIOS DEL SISTEMA           "
	echo "========================================="
	cut -d ":" -f 1 /etc/passwd | sort | more
	echo "-----------------------------------------"
	echo "Presione Enter para volver al menú principal..."
	read pausa
}

function buscar_usuario(){ 
	clear
	echo "Ingrese el apellido y nombre del usuario a buscar (apellidonombre): "
	read nombre
	usuario=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')
	
	grep -q "^${usuario}:" /etc/passwd
	if [ $? -eq 0 ]; then
		echo "El usuario '$usuario' EXISTE en el sistema. Presione Enter para continuar."
		read pausa
	else
		echo "El usuario '$usuario' NO existe en el sistema. Presione Enter para continuar."
		read pausa
	fi
}

function cambiar_contra_usuario(){ 
	clear
	echo "Ingrese el apellido y nombre del usuario (apellidonombre): "
	read nombre
	usuario=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')
	
	grep -q "^${usuario}:" /etc/passwd
	if [ $? -eq 0 ]; then
		echo "Se procede a cambiar la contraseña al usuario $usuario:"
		passwd "$usuario"
		read pausa
	else
		echo "El usuario '$usuario' no existe en el sistema. Presione Enter para continuar."
		read pausa
	fi
}

function bloquear_usuario(){
	clear
	echo "Ingrese el apellido y nombre del usuario a bloquear (apellidonombre): "
	read nombre
	usuario=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')
	
	grep -q "^${usuario}:" /etc/passwd
	if [ $? -eq 0 ]; then
		usermod -L "$usuario"
		echo "La cuenta del usuario '$usuario' ha sido bloqueada."
		echo "$(date +%Y-%m-%d-%H:%M:%S) Usuario $usuario bloqueado por $USER" >> /root/log/log_propios/usuarios.txt
		read pausa
	else
		echo "El usuario '$usuario' no existe en el sistema. Presione Enter para continuar."
		read pausa
	fi
}

function desbloquear_usuario(){
	clear
	echo "Ingrese el apellido y nombre del usuario a desbloquear (apellidonombre): "
	read nombre
	usuario=$(echo "$nombre" | tr '[:upper:]' '[:lower:]')
	
	grep -q "^${usuario}:" /etc/passwd
	if [ $? -eq 0 ]; then
		usermod -U "$usuario"
		echo "La cuenta del usuario '$usuario' ha sido desbloqueada."
		echo "$(date +%Y-%m-%d-%H:%M:%S) Usuario $usuario desbloqueado por $USER" >> /root/log/log_propios/usuarios.txt
		read pausa
	else
		echo "El usuario '$usuario' no existe en el sistema. Presione Enter para continuar."
		read pausa
	fi
}   
while [ $opc -ne 0 ]
do
	menu
	read -p "Ingrese la opción correspondiente: " opc
	case $opc in
		1) agregar_usuario ;;
		2) borrar_usuario ;;
		3) listar_usuarios ;;
		4) buscar_usuario ;;
		5) cambiar_contra_usuario ;;
		6) bloquear_usuario ;;
		7) desbloquear_usuario ;;
		0) echo "Saliendo del sistema..."; break ;; 
		*) 
			echo "Opción incorrecta. Presione Enter para reintentar."
			read pausa
			;;
	esac
done
