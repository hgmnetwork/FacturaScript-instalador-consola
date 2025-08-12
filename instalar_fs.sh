#!/bin/bash

# --- PASO 1: Pedir y validar la versión de instalación ---

echo "--- Instalador de FacturaScript para cPanel por HGMnetwork.com ---"
echo " "
echo "¿Qué versión de FacturaScript deseas instalar?"
echo "1) Estable (Recomendado)"
echo "2) Beta"

read -p "Selecciona una opción (1 o 2): " version_option

if [ "$version_option" == "1" ]; then
    DOWNLOAD_URL="https://facturascripts.com/DownloadBuild/1/stable"
    VERSION_NAME="estable"
elif [ "$version_option" == "2" ]; then
    DOWNLOAD_URL="https://facturascripts.com/DownloadBuild/1/beta"
    VERSION_NAME="beta"
else
    echo "Opción no válida. Se instalará la versión estable por defecto."
    DOWNLOAD_URL="https://facturascripts.com/DownloadBuild/1/stable"
    VERSION_NAME="estable"
fi

echo " "
echo "Has seleccionado la versión $VERSION_NAME."

# --- PASO 2: Pedir y validar el directorio de instalación ---

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

# --- PASO 3: Preguntar por el usuario de ejecución ---

echo " "
runuser=$(whoami)


# --- PASO 4: Descargar y descomprimir FacturaScript ---

echo " "
echo "Descargando la versión $VERSION_NAME de FacturaScript..."
wget "$DOWNLOAD_URL" -O facturascripts.zip > /dev/null 2>&1

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

# --- PASO 5: Asignar permisos ---

echo " "
echo "Asignando permisos..."
chown -R $runuser:$runuser "$installdir"
echo "Permisos asignados a $runuser."

echo " "
echo "--- Instalación completada ---"
echo "Para continuar con la instalación de FacturaScript, visita:"
echo "http://www.sudominio.com/${installdir}"
echo " "

