Script para poder instalar la ultima versión de FacturaScript por consola directamente.
Sólo se debe indicar el nombre del directorio y el script descargará y creará el directorio automáticamente.

Los ficheros los pondrá también con el usuario desde el que se instalada automáticamente.

Por ejemplo si se desea instalar en /home/usuario/public_html/FacturaScript y el usuario es facturaescript y grupo facturascript, 
se debe subir a /home/usuario/public_html/ darle permisos 755 (chmod 755 instalar_fs.sh)  y ejecutarlo ./instalar_fs.sh o el nombre que le den.
Preguntara el nombre del directorio por ejemplo en este ejemplo FacturaScript si ya existe el directorio preguntará si se desea sobre escribir o bien cancelar la instalación.

Una vez indicado procederá a descarga y copiar todo al directorio indicado y asignara el directorio y ficheros al usuario (por si se ejecuta como root, mantenga el usuario y ficheros correctos)

Usará Wget si no lo tienen instalado usara curl por compatibilidad.
