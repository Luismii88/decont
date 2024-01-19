# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
# and *optionally*:
# - uncompress the downloaded file with gunzip if the third
#   argument ($3) contains the word "yes"
# - filter the sequences based on a word contained in their header lines:
#   sequences containing the specified word in their header should be **excluded**
#
# Example of the desired filtering:
#
#   > this is my sequence
#   CACTATGGGAGGACATTATAC
#   > this is my second sequence
#   CACTATGGGAGGGAGAGGAGA
#   > this is another sequence
#   CCAGGATTTACAGACTTTAAA
#
#   If $4 == "another" only the **first two sequence** should be output





# Verifica si se proporciona el número correcto de argumentos
if [ "$#" -lt 2 ]; then
    echo "Uso: $0 <url_del_archivo> <directorio_salida> [descomprimir: si/no] [palabra_de_filtro]"
    exit 1
fi

# Argumentos
file_url=$1
output_directory=$2
uncompress=$3
filter_word=$4

# Crea el directorio de salida si no existe
#con el -p hacemos que los directorios intermedios que no existan se creen
#utilizo el $ para que el directorio se llame como el contenido de esa variable
mkdir -p "$output_directory"

# Extrae el nombre del archivo de la URL (sin el directorio)
filename=$(basename "$file_url")

# Descarga el archivo
#el -O permite ponerle un nombre personalizado al archivo descargado
wget -O "$output_directory/$filename" "$file_url"

# Descomprime el archivo si se solicita
if [ "$uncompress" == "yes" ]; then
    gunzip -k "$output_directory/$filename"
else
    echo "No se ha descomprimido el archivo"
fi

# Filtra las secuencias basadas en la palabra especificada
if [ -n "$filter_word" ]; then
    grep -B 1 -v "$filter_word" "$output_directory/$filename" > "$output_directory/filtered_file"
else
    echo "No se han proporcionado condiciones para el filtrado"
fi
