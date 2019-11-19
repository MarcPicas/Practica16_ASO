#!/bin/bash
#Aquesta Pràctica la he fet sol ja que el meu company no ha estat venint a ASO últimament i he acordat amb ell que cadascú la faria pel seu compte.


# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -eq 0 ]]
then
	echo " "
	echo 'Has ejecutdao el comando como superusuario. '
	echo ' '
else
	echo 'Tienes que ejecutar el comando como superusuario.'
	exit 1
fi
# If the user doesn't supply at least one argument, then give them help.
if [ -n "$1" ]; then 
	echo "Bienvenido,"
else
	echo "No has pasado ningún parámetro. "
	exit 1
fi
# The first parameter is the user name.
nombre=$1
echo "Tu nombre es: ${nombre}"
echo " "
# The rest of the parameters are for the account comments.

# Generate a password.
pass=$(openssl rand -base64 14)
echo "Tu contraseña es: ${pass}"
echo " "
# Create the user with the password.
sudo useradd -p $(openssl passwd -1 ${pass}) -c ${nombre} -m ${nombre}
# Check to see if the useradd command succeeded.
if [ $? -eq 0 ]
then
	echo "Se ha creado el usuario correctamente."
	echo " "
else
	echo "No se ha podido crear el usuario."
	exit 1
fi
# Set the password.
echo ${nombre}":"${pass} | chpasswd
# Check to see if the passwd command succeeded.
if [ $? -eq 0 ]
then
	echo "Se ha creado la contraseña correctamente."
	echo " "
else
	echo "No se ha podido crear la contraseña."
	exit 1
fi
# Force password change on first login.
echo "Es obligado cambiar la contraseña la primera vez que entras con este usuraio"
chage -d 0 ${nombre}
read -s pass2
echo ${nombre}":"${pass2} | chpasswd
#echo ${pass2} | passwd ${nombre}
# Display the username, password, and the host where the user was created.
echo "Tu nombre de usuario es: ${nombre}" 
echo "Tu contraseña es: ${pass2}"
echo "El host desde el que lo has creado es: ${HOSTNAME}"
