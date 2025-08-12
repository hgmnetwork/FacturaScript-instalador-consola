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

# --- PASO 3: Descargar y descomprimir FacturaScript (lógica mejorada) ---

echo " "
echo "Buscando comando para descarga (wget o curl)..."

download_url="https://facturascripts.com/DownloadBuild/1/stable"
output_file="facturascripts.zip"

if command -v wget &> /dev/null
then
    echo "Usando wget..."
    wget "$download_url" -O "$output_file" > /dev/null 2>&1
elif command -v curl &> /dev/null
then
    echo "Usando curl..."
    curl -sL "$download_url" -o "$output_file"
else
    echo "Error: No se encontró 'wget' ni 'curl'. Instala uno de los dos para continuar."
    exit 1
fi

if [ ! -f "$output_file" ]; then
    echo "Error: No se pudo descargar FacturaScript. Revisa la URL o tu conexión."
    exit 1
fi

echo "Creando y descomprimiendo archivos en el directorio '$installdir'..."
mkdir "$installdir"
unzip -q "$output_file" -d "$installdir" > /dev/null 2>&1
rm "$output_file"

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
