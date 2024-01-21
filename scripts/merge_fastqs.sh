# This script should merge all files from a given sample (the sample id is
# provided in the third argument ($3)) into a single file, which should be
# stored in the output directory specified by the second argument ($2).
#
# The directory containing the samples is indicated by the first argument ($1).

#verificamos siempre que se introduzcan todos los argumentos correctamente
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <directorio_entrada> <directorio_salida> <identificador_muestra>"
    exit 1
fi

input_directory=$1
output_directory=$2
sample_id=$3

if [ ! -d "$input_directory" ];then
	echo "El directorio de entrada indicado ($input_directory) no existe"
	mkdir -p "$input_directory"
fi

if [ ! -d "$output_directory" ];then
	echo "El directorio de salida indicado ($output_directory) no existe"
	mkdir -p "$output_directory"
fi

zcat "$input_directory"/"$sample_id"*.fastq.gz > "$output_directory"/"$sample_id".fastq

gzip "$output_directory"/"$sample_id".fastq

echo "Proceso completado sin errores."
