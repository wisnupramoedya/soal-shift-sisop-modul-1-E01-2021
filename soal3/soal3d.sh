if [[ ($(ls -d Kelinci_* Kucing_* | wc -l)) ]];
then
    PASSWORD=($(date "+%m%d%Y"))
    zip -P $PASSWORD -r Koleksi.zip Kucing_* Kelinci_* && rm -r Kucing_* Kelinci_*
fi
