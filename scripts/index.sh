
# Vamos a hacer una validación de argumentos como en todos los scripts
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <archivo_genoma> <directorio_salida_index>"
    exit 1
fi

#Argumentos
genome_file=$1
output_directory=$2

echo "Indexando el genoma en '$genome_file' en el directorio '$output_directory'..."

#comando STAR para indexar
STAR --runThreadN 2 --runMode genomeGenerate --genomeDir "$output_directory" \
 --genomeFastaFiles "$genome_file" --genomeSAindexNbases 9

echo "Indexación completada con éxito"
