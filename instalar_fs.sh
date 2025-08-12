#!/bin/bash

# --- PASO 1: Pedir y validar el directorio de instalación ---

echo "--- Instalador de FacturaScript para cPanel por HGMnetwork.com ---"
echo " "
read -p "Introduce el nombre del directorio para la instalación (ej. mi-tienda): " installdir

if [ -d "$installdir" ]; then
    echo "¡Atención! El directorio '$installdir' ya existe."
    read -p "¿Deseas sobreescribirlo y crear una copia de seguridad? (S/n): " confirm
    if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
        echo "Operación cancelada."
        exit 1
    fi
    echo "Creando copia de seguridad de '$installdir' a '$installdir.backup'..."
    mv "$installdir" "$installdir.backup"
fi

# --- PASO 2: Preguntar por el usuario de ejecución ---

echo " "
runuser=$(whoami)

# --- PASO 3: Descargar y descomprimir FacturaScript ---

echo " "
echo "Descargando la última versión de FacturaScript..."
wget https://facturascripts.com/DownloadBuild/1/stable -O facturascripts.zip > /dev/null 2>&1

if [ ! -f "facturascripts.zip" ]; then
    echo "Error: No se pudo descargar FacturaScript. Revisa la URL o tu conexión."
    exit 1
fi

echo "Creando y descomprimiendo archivos en el directorio '$installdir'..."
mkdir "$installdir"
unzip -q facturascripts.zip -d "$installdir" > /dev/null 2>&1
rm facturascripts.zip

mv "$installdir/facturascripts"/* "$installdir"
mv "$installdir/facturascripts"/.[!.]* "$installdir" 2>/dev/null
rmdir "$installdir/facturascripts"

# --- PASO 4: Asignar permisos ---

echo " "
echo "Asignando permisos..."
chown -R $runuser:$runuser "$installdir"
echo "Permisos asignados a $runuser."

echo " "
echo "--- Instalación completada ---"
echo "Para continuar con la instalación de FacturaScript, visita:"
echo "http://www.sudominio.com/${installdir}"
echo " "