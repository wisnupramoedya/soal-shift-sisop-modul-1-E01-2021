#!/bin/bash
download_move_data(){
    for i in {1..23}
    do
        wget --trust-server-names -a "Foto.log" $1
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
}

download_move_data "https://loremflickr.com/320/240/kitten"
