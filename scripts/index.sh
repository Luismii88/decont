# This script should index the genome file specified in the first argument ($1),
# creating the index in a directory specified by the second argument ($2).

# The STAR command is provided for you. You should replace the parts surrounded
# by "<>" and uncomment it.

# STAR --runThreadN 4 --runMode genomeGenerate --genomeDir <outdir> \
# --genomeFastaFiles <genomefile> --genomeSAindexNbases 9

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
