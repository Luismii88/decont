
# Vamos a intentar descargar los ficheros de esta forma
#while IFS= read -r url; do
#    bash scripts/download.sh "$url" data
#done < data/urls

#Sustituimos el bucle while para descargar por una linea con wget
wget -i data/urls -P data


# Descargamos el archivo de fasta de contaminaciones, descomprimimos y filtramos para quitar los small nuclear RNAs
bash scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz res yes "small nuclear"  #TODO

# Indexamos el archivo contaminants.fasta
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx


# Merge the samples into a single file
for input_file in data/*.fastq.gz
do
    # Obtener el identificador de muestra del nombre del archivo
    sample_id=$(basename "$input_file" .fastq.gz | cut -d'.' -f1)

    # Verificar si ya existe la muestra en el directorio de salida
    if [ ! -e "out/merged/${sample_id}_merged.fastq.gz" ]; then
	mkdir -p "out/merged"
        # Llamar al script merge_fastqs.sh solo para la primera aparición del identificador de muestra
        bash scripts/merge_fastqs.sh data out/merged "$sample_id"
    fi
done


# TODO: run cutadapt for all merged files
mkdir -p out/trimmed
mkdir -p log/cutadapt
for input_file in out/merged/*.fastq.gz
do
    sid=$(basename "$input_file" .fastq.gz)
    trimmed_file="out/trimmed/${sid}_trimmed.fastq.gz"
    log_file="log/cutadapt/cutadapt${sid}_cutadapt.log"

    cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
        -o "$trimmed_file" "$input_file" > "$log_file"
done



# TODO: run STAR for all trimmed files

mkdir -p out/star

for input_file in out/trimmed/*.fastq.gz
do
    # you will need to obtain the sample ID from the filename
    sid=$(basename "$input_file" _trimmed.fastq.gz)
    output_directory="out/star/$sid"
    mkdir -p out/star/$sid
   #mkdir -p "$output_directory"
    STAR --runThreadN 4 --genomeDir res/contaminants_idx \
       --outReadsUnmapped Fastx --readFilesIn <(gunzip -c "$input_file") \
       --outFileNamePrefix "$output_directory"/
done


# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
# tip: use grep to filter the lines you're interested in


log_file="log/pipeline_log.txt"
echo "Pipeline Execution Log" > "$log_file"
echo -e "\nCutadapt Logs:" >> "$log_file"
for log in log/cutadapt/*_cutadapt.log
do
    sample_id=$(basename "$log" _cutadapt.log)
    echo -e "\nSample: $sample_id" >> "$log_file"
    grep -E "Reads with adapters|total basepairs" "$log" >> "$log_file" 2>/dev/null || true
done


echo -e "\nSTAR Logs:" >> "$log_file"
for log in out/star/*/*Log.final.out
do
    sid=$(basename "$(dirname "$log")")
    echo -e "\nSample: $sid" >> "$log_file"
    grep -E "Uniquely mapped reads %|% of reads mapped to multiple loci|% of reads mapped to too many loci" "$log" >> "$log_file" 2>/dev/null || true
done

echo "Pipeline completed successfully. Log file: $log_file"
