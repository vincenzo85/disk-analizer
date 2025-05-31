#!/bin/bash

# Script per analisi completa dello spazio disco
# Versione: 1.0
# Autore: Script generato per analisi sistema

echo "=================================================="
echo "    ANALISI COMPLETA SPAZIO DISCO - $(date)"
echo "=================================================="

# Funzione per convertire bytes in formato leggibile
bytes_to_human() {
    local bytes=$1
    if [ $bytes -gt 1073741824 ]; then
        echo "$(( bytes / 1073741824 )) GB"
    elif [ $bytes -gt 1048576 ]; then
        echo "$(( bytes / 1048576 )) MB"
    elif [ $bytes -gt 1024 ]; then
        echo "$(( bytes / 1024 )) KB"
    else
        echo "${bytes} B"
    fi
}

# Variabili globali per il riepilogo
TOTAL_DISK_SPACE=$(df / | tail -1 | awk '{print $2}')
TOTAL_DISK_SPACE_BYTES=$((TOTAL_DISK_SPACE * 1024))

echo -e "\n📊 INFORMAZIONI GENERALI SISTEMA"
echo "================================="
df -h / | head -2
echo ""

# 1. FILE SUPERIORI A 1GB
echo -e "\n🔍 FILE SUPERIORI A 1GB"
echo "========================"
echo "Ricerca in corso..."
large_files_temp="/tmp/large_files.tmp"
find / -type f -size +1G 2>/dev/null | head -20 > "$large_files_temp"

if [ -s "$large_files_temp" ]; then
    echo -e "\nTOP 20 FILE PIÙ GRANDI (>1GB):"
    echo "-------------------------------"
    while read -r file; do
        if [ -f "$file" ]; then
            size=$(stat -c%s "$file" 2>/dev/null)
            size_human=$(bytes_to_human $size)
            echo "$(printf '%8s' "$size_human") - $file"
        fi
    done < "$large_files_temp" | sort -hr
    
    large_files_total=$(find / -type f -size +1G -exec stat -c%s {} \; 2>/dev/null | awk '{sum+=$1} END {print sum+0}')
    large_files_human=$(bytes_to_human $large_files_total)
    echo -e "\nTOTALE FILE >1GB: $large_files_human"
else
    echo "Nessun file superiore a 1GB trovato."
    large_files_total=0
fi

# 2. CONTAINER DOCKER
echo -e "\n🐳 ANALISI DOCKER"
echo "=================="
if command -v docker &> /dev/null; then
    if systemctl is-active --quiet docker 2>/dev/null || pgrep dockerd > /dev/null; then
        echo "Docker installato e in esecuzione"
        
        # Spazio occupato da Docker
        docker_root=$(docker info 2>/dev/null | grep "Docker Root Dir" | cut -d: -f2 | xargs)
        if [ -d "$docker_root" ]; then
            docker_size=$(du -sb "$docker_root" 2>/dev/null | cut -f1)
            docker_size_human=$(bytes_to_human $docker_size)
            echo "Spazio totale Docker: $docker_size_human"
            echo "Percorso Docker: $docker_root"
        fi
        
        # Informazioni sui container
        echo -e "\nContainer attivi:"
        docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Size}}" 2>/dev/null || echo "Nessun container attivo"
        
        echo -e "\nImmagini Docker:"
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" 2>/dev/null || echo "Nessuna immagine trovata"
        
        # Pulizia suggerita
        echo -e "\n💡 Spazio recuperabile con 'docker system prune -a':"
        docker system df 2>/dev/null || echo "Impossibile calcolare"
    else
        echo "Docker installato ma non in esecuzione"
        docker_size=0
    fi
else
    echo "Docker non installato"
    docker_size=0
fi

# 3. ANALISI FILE MULTIMEDIALI E ALTRI FORMATI
echo -e "\n🎬 ANALISI FILE PER CATEGORIA"
echo "============================="

# Array per memorizzare i risultati
declare -A file_categories
declare -A file_counts

# Definizione categorie
categories=(
    "Video MKV:.mkv"
    "Video AVI:.avi"
    "Video MP4:.mp4"
    "Video MOV:.mov"
    "Audio MP3:.mp3"
    "Audio FLAC:.flac"
    "Audio WAV:.wav"
    "Documenti PDF:.pdf"
    "Archivi ZIP:.zip"
    "Archivi RAR:.rar"
    "Archivi 7Z:.7z"
    "Archivi TAR:.tar"
    "Archivi TAR.GZ:.tar.gz"
    "Immagini ISO:.iso"
    "Immagini IMG:.img"
    "Foto JPEG:.jpg,.jpeg"
    "Foto PNG:.png"
    "Foto RAW:.raw,.cr2,.nef"
    "Documenti DOCX:.docx"
    "Documenti ODT:.odt"
    "Fogli Excel:.xlsx,.xls"
    "Database:.db,.sqlite"
)

echo "Scansione in corso per categoria..."

for category in "${categories[@]}"; do
    name="${category%:*}"
    extensions="${category#*:}"
    
    total_size=0
    count=0
    
    # Converti le estensioni in parametri per find
    IFS=',' read -ra EXTS <<< "$extensions"
    find_args=""
    for ext in "${EXTS[@]}"; do
        if [ -z "$find_args" ]; then
            find_args="-name '*$ext'"
        else
            find_args="$find_args -o -name '*$ext'"
        fi
    done
    
    # Esegui la ricerca
    while IFS= read -r -d '' file; do
        if [ -f "$file" ]; then
            size=$(stat -c%s "$file" 2>/dev/null || echo 0)
            total_size=$((total_size + size))
            count=$((count + 1))
        fi
    done < <(eval "find / -type f \( $find_args \) -print0 2>/dev/null")
    
    if [ $total_size -gt 0 ]; then
        file_categories["$name"]=$total_size
        file_counts["$name"]=$count
    fi
done

# 4. RIEPILOGO GLOBALE
echo -e "\n📈 RIEPILOGO GLOBALE"
echo "===================="

total_analyzed=0
total_analyzed=$((total_analyzed + large_files_total))
total_analyzed=$((total_analyzed + docker_size))

# Aggiungi dimensioni delle categorie
for category in "${!file_categories[@]}"; do
    total_analyzed=$((total_analyzed + ${file_categories[$category]}))
done

echo -e "\nSPAZIO DISCO TOTALE: $(bytes_to_human $TOTAL_DISK_SPACE_BYTES)"
echo "SPAZIO ANALIZZATO: $(bytes_to_human $total_analyzed)"

# Calcola percentuale di utilizzo per ogni categoria
echo -e "\n📊 DETTAGLIO PER CATEGORIA:"
echo "============================="

# Mostra file grandi
if [ $large_files_total -gt 0 ]; then
    percentage=$(echo "scale=2; $large_files_total * 100 / $TOTAL_DISK_SPACE_BYTES" | bc -l 2>/dev/null || echo "0")
    printf "%-20s %10s (%5.2f%%)\n" "File >1GB:" "$(bytes_to_human $large_files_total)" "$percentage"
fi

# Mostra Docker
if [ $docker_size -gt 0 ]; then
    percentage=$(echo "scale=2; $docker_size * 100 / $TOTAL_DISK_SPACE_BYTES" | bc -l 2>/dev/null || echo "0")
    printf "%-20s %10s (%5.2f%%)\n" "Docker:" "$(bytes_to_human $docker_size)" "$percentage"
fi

# Mostra categorie ordinate per dimensione
for category in $(for cat in "${!file_categories[@]}"; do echo "$cat:${file_categories[$cat]}"; done | sort -t: -k2 -nr | cut -d: -f1); do
    size=${file_categories[$category]}
    count=${file_counts[$category]}
    percentage=$(echo "scale=2; $size * 100 / $TOTAL_DISK_SPACE_BYTES" | bc -l 2>/dev/null || echo "0")
    printf "%-20s %10s (%5.2f%%) - %d file\n" "$category:" "$(bytes_to_human $size)" "$percentage" "$count"
done

# 5. TOP DIRECTORY PER DIMENSIONE
echo -e "\n📁 TOP 10 DIRECTORY PIÙ GRANDI"
echo "==============================="
du -h --max-depth=2 / 2>/dev/null | sort -hr | head -10

# 6. SUGGERIMENTI DI PULIZIA
echo -e "\n💡 SUGGERIMENTI PER LIBERARE SPAZIO"
echo "==================================="
echo "1. Pulisci cache del sistema:"
echo "   sudo apt autoremove && sudo apt autoclean  # Ubuntu/Debian"
echo "   sudo yum clean all                          # CentOS/RHEL"
echo ""
echo "2. Pulisci log di sistema:"
echo "   sudo journalctl --vacuum-time=30d"
echo ""
echo "3. Pulisci Docker (se installato):"
echo "   docker system prune -a"
echo ""
echo "4. Trova e rimuovi file duplicati:"
echo "   fdupes -r /home/\$USER"
echo ""
echo "5. Pulisci cache utente:"
echo "   rm -rf ~/.cache/*"

# Cleanup file temporanei
rm -f "$large_files_temp"

echo -e "\n=================================================="
echo "    ANALISI COMPLETATA - $(date)"
echo "=================================================="