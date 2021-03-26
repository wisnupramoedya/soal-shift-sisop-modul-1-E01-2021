# Unzipping
# cd /home/wisnupramoedya/Programming/Bash/modul-1/soal-shift-sisop-modul-1-E01-2021/soal3 && if [[ ($(ls Koleksi.zip | wc -l)) ]]; then modif_date=$(stat --format="%y" Koleksi.zip); pass_date=$(date -d "$modif_date" "+%m%d%Y"); unzip -P $pass_date Koleksi.zip; rm Koleksi.zip; fi;

# Zip
# * 7-18 * * 1-5 cd /home/wisnupramoedya/Programming/Bash/modul-1/soal-shift-sisop-modul-1-E01-2021/soal3 && bash soal3d.sh