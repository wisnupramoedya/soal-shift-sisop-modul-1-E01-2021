counter_ls() {
    d_kelinci=$(ls -d Kelinci_* | wc -l)
    d_kucing=$(ls -d Kucing_* | wc -l)
    
    if [[ $d_kucing -lt $d_kelinci ]]
    then
        echo 1
    else
        echo 0
    fi
}
kucing="$(counter_ls)"

URL_KUCING="https://loremflickr.com/320/240/kitten"
URL_KELINCI="https://loremflickr.com/320/240/bunny"

FOLDERNAME_KUCING="Kucing_"
FOLDERNAME_KELINCI="Kelinci_"

foldername_generate(){
    local str=($(date "+%d-%m-%Y"))
    echo "$1$str"
}

collected_data(){
    img_array=($(ls *.jpg))
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

    img_array=($(ls *.jpg))
    img_array_duplicate=($(ls *.jpg.*))

    for i in "${img_array_duplicate[@]}"
    do
        rm $i
    done

    for i in "${!img_array[@]}"
    do
        for j in "${!img_array[@]}"
        do
            if [[ $i -ne $j ]]
            then
                if cmp -s "${img_array[$i]}" "${img_array[$j]}"
                then
                    rm ${img_array[$i]}
                fi
            fi
        done
    done

    img_array=($(ls *.jpg))
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
    mkdir "$foldername"
    collected_data $foldername
}

if [[ $kucing -eq 1 ]]
then
    download_move_data $URL_KUCING $FOLDERNAME_KUCING
else
    download_move_data $URL_KELINCI $FOLDERNAME_KELINCI
fi

