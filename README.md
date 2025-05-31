# disk-analizer
Linux # 🔍 Linux Disk Space Analyzer

Un potente script bash per l'analisi completa dello spazio disco su sistemi Linux. Identifica rapidamente cosa occupa più spazio sul tuo sistema con report dettagliati e suggerimenti di ottimizzazione.

## 🚀 Caratteristiche

- ✅ **Analisi file grandi**: Identifica tutti i file superiori a 1GB
- 🐳 **Monitoraggio Docker**: Analizza container, immagini e spazio totale
- 🎬 **Categorizzazione multimediale**: Video (MKV, AVI, MP4), Audio (MP3, FLAC, WAV)
- 📄 **Documenti e archivi**: PDF, ZIP, RAR, 7Z, ISO e molto altro
- 📊 **Report con percentuali**: Visualizzazione chiara dell'utilizzo disco
- 🧹 **Suggerimenti di pulizia**: Comandi pronti per liberare spazio
- ⚡ **Veloce e sicuro**: Gestione errori e ottimizzazioni integrate

## 📋 Requisiti

### Sistemi supportati
- Ubuntu/Debian
- CentOS/RHEL
- Fedora
- Arch Linux
- Qualsiasi distribuzione Linux con bash

### Dipendenze
```bash
# Ubuntu/Debian
sudo apt install bc findutils coreutils

# CentOS/RHEL/Fedora
sudo yum install bc findutils coreutils
# oppure
sudo dnf install bc findutils coreutils

# Arch Linux
sudo pacman -S bc findutils coreutils
```

## 🛠️ Installazione

### Metodo 1: Clone diretto
```bash
git clone https://github.com/tuousername/linux-disk-analyzer.git
cd linux-disk-analyzer
chmod +x disk_analyzer.sh
```

### Metodo 2: Download diretto
```bash
wget https://raw.githubusercontent.com/tuousername/linux-disk-analyzer/main/disk_analyzer.sh
chmod +x disk_analyzer.sh
```

## 🚀 Utilizzo

### Analisi completa (raccomandato)
```bash
sudo ./disk_analyzer.sh
```

### Analisi limitata (senza privilegi root)
```bash
./disk_analyzer.sh
```

### Salva output in file
```bash
sudo ./disk_analyzer.sh > disk_report_$(date +%Y%m%d).txt
```

## 📊 Output dello script

```
==================================================
    ANALISI COMPLETA SPAZIO DISCO - 2025-05-31
==================================================

📊 INFORMAZIONI GENERALI SISTEMA
=================================
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       100G   75G   20G  79% /

🔍 FILE SUPERIORI A 1GB
========================
     5.2GB - /home/user/video/movie.mkv
     3.1GB - /var/lib/docker/overlay2/...
     2.8GB - /home/user/backup.tar.gz

🐳 ANALISI DOCKER
==================
Spazio totale Docker: 15.6GB
Container attivi: 3
Immagini Docker: 12

🎬 ANALISI FILE PER CATEGORIA
=============================
Video MKV:           8.5GB (8.50%) - 15 file
Archivi ZIP:         4.2GB (4.20%) - 234 file
Documenti PDF:       2.1GB (2.10%) - 1,156 file
...

💡 SUGGERIMENTI PER LIBERARE SPAZIO
===================================
1. Pulisci cache del sistema: sudo apt autoremove
2. Pulisci Docker: docker system prune -a
3. Rimuovi log vecchi: sudo journalctl --vacuum-time=30d
```

## 🔧 Configurazione avanzata

### Personalizzare categorie di file
Modifica l'array `categories` nello script per aggiungere nuovi tipi di file:

```bash
categories=(
    "Video Custom:.mkv,.mp4,.avi"
    "Audio Custom:.mp3,.flac"
    "Documenti Custom:.pdf,.docx"
    # Aggiungi le tue categorie qui
)
```

### Modificare soglia file grandi
Cambia il parametro `-size +1G` per file di dimensioni diverse:
```bash
# Per file > 500MB
find / -type f -size +500M

# Per file > 2GB  
find / -type f -size +2G
```

## 🎯 Casi d'uso

- **Amministratori di sistema**: Monitoraggio spazio server
- **Sviluppatori**: Pulizia ambienti di sviluppo
- **Data Scientists**: Gestione dataset e modelli ML
- **DevOps**: Ottimizzazione container e CI/CD
- **Utenti desktop**: Pulizia sistema personale

## 🤝 Contribuire

1. Fai fork del repository
2. Crea un branch per la tua feature (`git checkout -b feature/AmazingFeature`)
3. Commit delle modifiche (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Apri una Pull Request

### Linee guida contribuzione
- Mantieni compatibilità bash
- Aggiungi test per nuove funzionalità  
- Documenta le modifiche nel README
- Segui lo stile di codifica esistente

## 📝 Roadmap

- [ ] Supporto output JSON/XML
- [ ] Interface web opzionale
- [ ] Integrazione Prometheus/Grafana
- [ ] Scheduling automatico con cron
- [ ] Plugin per diversi cloud provider
- [ ] Supporto Windows Subsystem for Linux

## 🐛 Segnalazione bug

Hai trovato un bug? [Apri una issue](https://github.com/tuousername/linux-disk-analyzer/issues) includendo:

- Distribuzione Linux e versione
- Output dell'errore
- Passi per riprodurre il problema
- Log completo se possibile

## 📄 Licenza

Questo progetto è sotto licenza MIT - vedi il file [LICENSE](LICENSE) per dettagli.

## 🙏 Riconoscimenti

- Ispirato dalle migliori pratiche di amministrazione Linux
- Testato su diverse distribuzioni della community
- Grazie a tutti i contributor che hanno reso possibile questo progetto

## ⭐ Ti è piaciuto?

Se questo script ti ha aiutato, considera di:
- ⭐ Mettere una stella al repository
- 🍴 Fare fork per i tuoi progetti
- 📢 Condividere con la community
- 💬 Lasciare feedback nelle issues

---

**Mantieni il tuo sistema Linux sempre ottimizzato! 🐧✨**Disk Analizer
