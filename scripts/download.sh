

# Verifica si se proporciona el número correcto de argumentos
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 <url_del_archivo> <directorio_salida> [descomprimir: yes/no] [palabra_de_filtrado]"
    exit 1
fi

# Argumentos
file_url=$1
output_directory=$2
uncompress=$3
keyword=$4

# Crea el directorio de salida si no existe
#con el -p hacemos que los directorios intermedios que no existan se creen
#utilizo el $ para que el directorio se llame como el contenido de esa variable
# Con el if comprobamos si esta o no creado el directorio

if [ ! -d "$output_directory" ]; then
	mkdir -p "$output_directory"
fi

# Extrae el nombre del archivo de la URL (sin el directorio)
filename=$(basename "$file_url")

# Descarga el archivo
#el -O permite ponerle un nombre personalizado al archivo descargado
wget -O "$output_directory/$filename" "$file_url"

# Descomprime el archivo si se solicita
if [ "$uncompress" == "yes" ]; then
    gunzip -k "$output_directory/$filename"
    filename="${filename%.gz}"  # Actualiza el nombre del archivo sin la extensión .gz
    echo "El archivo ha sido descomprimido"
else
    echo "No se ha descomprimido el archivo"
fi

#Vamos a verificar si el archivo descomprimido existe antes de continuar para evitar errores
if [ -e "$output_directory/$filename" ]; then

# Filtra las secuencias basadas en la palabra especificada

	if [ ! -z "$keyword" ]; then
# Filtrar y eliminar por palabra con seqkit
        seqkit grep -v -n -r -p "$keyword" "$output_directory/$filename" > "$output_directory/${filename%.*}_filtered.fasta"

		echo "Se han filtrado las secuencias que contienen la palabra clave $keyword"
    	else
		echo "No se han proporcionado condiciones para el filtrado"
	fi
else
	echo "Error: El archivo descomprimido no existe. Verifica posibles fallos en la descompresion"
fi

echo "Proceso completado sin fallos"
