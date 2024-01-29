# Vamos a crear un script para que borre los archivos creados dependiendo de los argumentos que le demos


# Argumentos posibles: "data", "res", "out", "logs"

if [ "$#" -eq 0 ]; then
    	rm -rf data res out logs
	find data -type f ! -name "urls" -exec rm -f {} +
else
    for arg in "$@"; do
        rm -rf "$arg" 2>/dev/null
	echo "Se ha eliminado: $arg"
    done
fi

