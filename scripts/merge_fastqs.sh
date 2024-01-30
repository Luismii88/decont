
# Verificamos siempre que se introduzcan todos los argumentos correctamente
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <directorio_entrada> <directorio_salida> <identificador_muestra>"
    exit 1
fi

input_directory=$1
output_directory=$2
sample_id=$3

# Vamos a verificar si existen los directorios de entrada y salida, si no los crearemos
if [ ! -d "$input_directory" ];then
	echo "El directorio de entrada indicado ($input_directory) no existe"
	echo "Creando directorio de entrada ..."
	mkdir -p "$input_directory"
	echo "El directorio $input_directory ha sido creado con exito"
else
	echo "Directorio de entrada: $input_directory"
fi

if [ ! -d "$output_directory" ];then
	echo "El directorio de salida indicado ($output_directory) no existe"
	echo "Creando directorio de salida ..."
	mkdir -p "$output_directory"
	echo "El directorio $output_directory ha sido creado con exito"
else
	echo "Directorio de salida: $output_directory"
fi

# Vamos a fusionar los archivos
zcat "$input_directory"/"$sample_id"*.fastq.gz > "$output_directory"/"$sample_id".fastq

# Volvemos a comprimir
gzip -f "$output_directory"/"$sample_id".fastq

echo "Proceso completado sin errores."
