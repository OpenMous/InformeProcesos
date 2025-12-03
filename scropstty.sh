#!/bin/bash
# Variables
procesos_registrados=0 procesos_eliminados=0
# Funciones
flog() { # Función que define el fichero log
    log="$(pwd)/logs/log.txt"
    log_dir="$(pwd)/logs/"
    if [ ! -e $log ]; then
        mkdir "$(pwd)/logs" 2> /dev/null
        echo "Fichero log creado por $user el $(date "+%d-%m-%Y")" >> $log
    fi
    echo "=========" >> $log
    echo "$(whoami) ha ejecutado el script [$0 $fichero] a $(date "+%d-%m-%Y")" >> $log
}
function fman( # Manual de uso del script
    echo "-----"
    echo "$0: Script para guardar los procesos de un usuario"
    echo "El script $0 debe ejecutarse indicando un usuario valido con la opción -u"
    echo "Puede utiizar tambien la opción -t para indicar la terminal de la cual quiere extraer los procesos"
    echo "-----"
)
fcontrol_opciones() { # Control de opciones y argumentos del script 
    while getopts "u:t:" opt; do
        case $opt in
            u)
                usu_existe=$(cat /etc/passwd | cut -d ":" -f1 | grep -w "^${OPTARG}$")
                if [ -n $usu_existe ]; then
                    user=${OPTARG}
                else
                    echo "El usuario ${OPTARG} no existe" | tee -a $log
                fi
                ;;
            t)
                if [ ! -e ${OPTARG} ]; then
                    echo "La tty ${OPTARG} no existe, se generará el informe sobre $(tty)" | tee -a $log
                    echo "Si introduce una terminal debe hacerlo con la siguiente sintaxis pts/nº"
                else
                    terminal=${OPTARG}
                fi
                ;;
            *)
                echo "Opción invalida" | tee -a $log
                fman
                ;;
        esac
    done
}
# Programas
# --
flog # LLamada a la función log
# --
fcontrol_opciones "$@" # Llamada al control de opciones y argumentos
# --
# Creación del informe del usuario
fichero_procesos="$(pwd)/logs/procesos_$user.log"
# --
if [ -n $terminal ]; then # Opción -t
    # --
    ps -u $user | grep "$terminal" > $fichero_procesos
    echo "Se ha generado un informe con los procesos de $user sobre el terminal $terminal" | tee -a $log
    echo "Podrá encontrarlo en $fichero_procesos"
    creado=1
    # --
else # Opción default
    # --
    ps -u $user | grep -v "PID" > $fichero_procesos
    echo "Se ha generado un informe con los procesos de $user" | tee -a $log
    echo "Podrá encontrarlo en $fichero_procesos"
    creado=1
    # --
fi
# --
while true; do # Decisión de matar procesos (aceptando solo una respuesta valida)
    read -p "¿Quiere matar alguno de los procesos? (s/n) " sn
    if [[ $sn == "s" ]] || [[ $sn == "S" ]]; then
        sn=1
        break
    elif [[ $sn == "n" ]] || [[ $sn == "N" ]]; then
        sn=0
        break
    else
        echo "Valor incorrecto, debes introducir una s o n"
    fi
done
# Gestión de asesinato de procesos
if [ $creado -eq 1 ] && [ $sn -eq 1 ]; then # Control de estado del fichero y decisión
    # --
    while IFS= read -r linea; do # Lectura del fichero y asesinato de procesos
        #--
        nombre=$(echo $linea | awk '{print $4}')
        pid=$(echo $linea | awk '{print $1}')
        # --
        read -p "¿Quiere eliminar el proceso $nombre? (s/N)" sn < /dev/tty
        # --
        if [[ $sn == "s" ]] || [[ $sn == "S" ]]; then # Decisión de eliminar el proceso
            kill -9 $pid
            echo "Se ha eliminado el proceso $pid" | tee -a >> $log
            ((procesos_eliminados++))
        fi
        ((procesos_registrados++))
        # --
    done < $fichero_procesos
    # --
    echo "De los $procesos_registrados procesos registrados, se han eliminado $procesos_eliminados" | tee -a $log
    # --
fi
echo "Script finalizado" >> $log
