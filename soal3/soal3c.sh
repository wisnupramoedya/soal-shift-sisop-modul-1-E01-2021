datediff() {
    d1=$(date -d "now" +%s)
    d2=$(date -d "Mar 26 2021" +%s)
    echo $(( (d1 - d2) / 86400 ))
}
diff="$(datediff)"
echo $diff

url_kucing="https://loremflickr.com/320/240/kitten"
url_kelinci="https://loremflickr.com/320/240/bunny"

foldername_kucing="Kucing_"
foldername_kelinci="Kelinci_"

foldername_generate(){
    local str=($(date "+%d-%m-%Y"))
    echo "$1$str"
}

collected_data(){
    img_array=($(ls *.jpg))
    
    mkdir "$1"
    mv "Foto.log" "$1/Foto.log"
    for i in "${!img_array[@]}"
    do
        mv "${img_array[$i]}" "$1/${img_array[$i]}"
    done
}

download_move_data(){
    for i in {1..23}
    do
        wget --trust-server-names -a "Foto.log" "$1"
    done

    img_array_duplicate=($(ls *.jpg.*))
    img_array=($(ls *.jpg))

    for i in "${img_array_duplicate[@]}"
    do
        rm $i
    done

    for i in "${!img_array[@]}"
    do
        if [[ $i -lt 9 ]]
        then
            mv "${img_array[$i]}" "Koleksi_0$((i+1)).jpg"
        else
            mv "${img_array[$i]}" "Koleksi_$((i+1)).jpg"
        fi
    done

    foldername=$(foldername_generate $2)
    collected_data $foldername
}

if [[ $(( $diff % 2 )) -eq 0 ]]
then
    download_move_data $url_kucing $foldername_kucing
else
    download_move_data $url_kelinci $foldername_kelinci
fi

