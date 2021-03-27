# soal-shift-sisop-modul-1-E01-2021
Sebagai tugas pengerjaan modul 1 SISOP E 2021.

## Soal No.1
Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, ticky. Terdapat 2 laporan yang harus dia buat, yaitu laporan daftar peringkat pesan error terbanyak yang dibuat oleh ticky dan laporan penggunaan user pada aplikasi ticky. Untuk membuat laporan tersebut, Ryujin harus melakukan beberapa hal berikut:
### 1.a
Mengumpulkan informasi dari log aplikasi yang terdapat pada file syslog.log. Informasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. Karena Ryujin merasa kesulitan jika harus memeriksa satu per satu baris secara manual, dia menggunakan regex untuk mempermudah pekerjaannya. Bantulah Ryujin membuat regex tersebut.
### 1.b
Kemudian, Ryujin harus menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.
### 1.c
Ryujin juga harus dapat menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya.

***Setelah semua informasi yang diperlukan telah disiapkan, kini saatnya Ryujin menuliskan semua informasi tersebut ke dalam laporan dengan format file csv.***

### 1.d
Semua informasi yang didapatkan pada poin b dituliskan ke dalam file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak.
Contoh:
```
Error,Count
Permission denied,5
File not found,3
Failed to connect to DB,2
```


### 1.e
Semua informasi yang didapatkan pada poin c dituliskan ke dalam file user_statistic.csv dengan header Username,INFO,ERROR diurutkan berdasarkan username secara ascending.
Contoh:
```
Username,INFO,ERROR
kaori02,6,0
kousei01,2,2
ryujin.1203,1,3
```
**Catatan :**
- Setiap baris pada file syslog.log mengikuti pola berikut:
 <time> <hostname> <app_name>: <log_type> <log_message> (<username>)
- Tidak boleh menggunakan AWK

## Penyelesaian No.1

### 1.a
Untuk mengumpulkan nformasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris log, maka digunakan `grep "ticky" syslog.log | cut -d ':' -f 4-` dimana kita menggunakan `grep` dan `cut` dengan delimiter `":"` lalu memilih field `4-` yang artinya field ke 4 dan seterusnya.
```
grep "ticky" syslog.log | cut -d ':' -f 4-
```

### 1.b
Pertama, kita assign variabel `perma` untuk menyimpan pesan-pesan error dengan `grep "ERROR" syslog.log | cut -d ' ' -f 7- | rev | cut -d ' ' -f 2- | rev | tr ' ' '*'` yang menggunakan `cut` seperti soal 1.a, lalu `rev` untuk mereverse sebuah baris, setelahnya digunakan `tr` untuk mengubah spasi per baris menjadi "*" (asterisk).
```
perma=""
permafix=""

for masalah in `grep "ERROR" syslog.log | cut -d ' ' -f 7- | rev | cut -d ' ' -f 2- | rev | tr ' ' '*'`
do
if [[ "$perma" != *"$masalah"* ]]
then
    perma+="${masalah} "
fi
done
```

Lalu akan dihapus duplikat dengan mensortir `perma` dengan isi dari syslog.log, hasil dari penghapusan ini di assign ke variabel baru `permafix` menggunakan `for in` sambil menghitung jumlah errornya yang diassign nilainya ke variabel `count`. 
```
for tes in `echo "$perma" | tr ' ' '\n'`
do

count=0

for typ in `grep "ERROR" syslog.log | cut -d ' ' -f 7- | rev | cut -d ' ' -f 2- | rev | tr ' ' '*' | tr ' ' '\n'`
do

if [ "$typ" = "$tes" ]
then
count=$((count+1))
fi

done

permafix+="$count#$tes,$count "
done
```
### 1.c
Untuk mengambil nama user, kami menggunakan `grep` dengan option `o` atau only. Regex untuk mencarinya digunakan `\(\w+\.?\w+?\)` karena letak username selalu diantara kurung awal dan buka ( `"("` dan `")"` ). lalu hasilnya diassign ke variabel `user`
```
for entry in `grep -oP "\(\w+\.?\w+?\)" syslog.log | cut -c2- | rev | cut -c2- | rev`
do
if [[ "$user" != *"$entry"* ]]
then
    user+="${entry} "
fi
done
```

Lalu, akan dihitung jumlah error dan info setiap usernya. Digunakan ***nested loop***, menyocokkan antara nama-nama user dengan `error` atau `info` yang dilakukan masing-masing user yang terdapat di `syslog.log`. Hasil tidak disimpan melainkan langsung ditampilkan. 

```
for pengguna in `echo "$user" | tr ' ' '\n' | sort`
do

erro=0
inf=0

for type in `grep -w "$pengguna" syslog.log`
do

if [ "$type" = "ERROR" ]
then
erro=$((erro+1))
elif [ "$type" = "INFO" ]
then
inf=$((inf+1))
fi

done
```
### 1.d
Lanjutan dari no `1.b`, Variabel `permafix` di `sort` secara descending. Sambil menyimpan `Error` beserta `Count`nya ke `error_message.csv`
```
echo "Error,Count" > error_message.csv
echo $permafix | tr ' ' '\n' | sort -V -r | cut -d '#' -f 2- | tr '*' ' ' >> error_message.csv
```
### 1.e
Lanjutan dari no `1.c`, karena ***nested loop*** belum selesai. Selanjutnya ditampilkan hasilnya ke `user_statistic.csv`

```
echo 'Username,INFO,ERROR' > user_statistic.csv
for
.			#
.			#	for 
.			#	pada
for			#	no
.			#	1.c
.			#
.			#
done
.
echo $pengguna,$inf,$erro >> user_statistic.csv
done
```



## Soal No.2
Steven dan Manis mendirikan sebuah startup bernama “TokoShiSop”. Sedangkan kamu
dan Clemong adalah karyawan pertama dari TokoShiSop. Setelah tiga tahun bekerja,
Clemong diangkat menjadi manajer penjualan TokoShiSop, sedangkan kamu menjadi
kepala gudang yang mengatur keluar masuknya barang.

Tiap tahunnya, TokoShiSop mengadakan Rapat Kerja yang membahas bagaimana hasil
penjualan dan strategi kedepannya yang akan diterapkan. Kamu sudah sangat
menyiapkan sangat matang untuk raker tahun ini. Tetapi tiba-tiba, Steven, Manis, dan
Clemong meminta kamu untuk mencari beberapa kesimpulan dari data penjualan
“Laporan-TokoShiSop.tsv”.
### 2.a
Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui
**Row ID** dan **profit percentage terbesar** (jika hasil profit percentage terbesar
lebih dari 1, maka ambil Row ID yang paling besar). Karena kamu bingung,
Clemong memberikan definisi dari profit percentage, yaitu:
```Profit Percentage = (Profit/(Sales-Profit))```
### 2.b
Clemong memiliki rencana promosi di Albuquerque menggunakan metode MLM.
Oleh karena itu, Clemong membutuhkan daftar **nama customer pada transaksi tahun 2017 di Albuquerque**.
### 2.c
TokoShiSop berfokus tiga segment customer, antara lain: Home Office,
Customer, dan Corporate. Clemong ingin meningkatkan penjualan pada segmen
customer yang paling sedikit. Oleh karena itu, Clemong membutuhkan **segment customer** 
dan **jumlah transaksinya yang paling sedikit**.
### 2.d
TokoShiSop membagi wilayah bagian (region) penjualan menjadi empat bagian,
antara lain: Central, East, South, dan West. Manis ingin mencari **wilayah bagian(region) yang memiliki total keuntungan (profit) paling sedikit** dan **total keuntungan wilayah tersebut**.
### 2.e
Membuat sebuah script yang akan menghasilkan file “hasil.txt” yang memiliki format 
sebagai berikut:
```
Transaksi terakhir dengan profit percentage terbesar yaitu *ID
Transaksi* dengan persentase *Profit Percentage*%.

Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
*Nama Customer1*
*Nama Customer2* dst

Tipe segmen customer yang penjualannya paling sedikit adalah *Tipe
Segment* dengan *Total Transaksi* transaksi.

Wilayah bagian (region) yang memiliki total keuntungan (profit) yang
paling sedikit adalah *Nama Region* dengan total keuntungan *Total
Keuntungan (Profit)*
```
**Catatan :**
- Gunakan bash,awk,dan command pendukung
- Script pada poin (**e**) memiliki nama file ‘soal2_generate_laporan_ihir_shisop.sh’

## Penyelesaian No.2 :
### 2.a
Untuk mendapatkan nilai persentase terbesar beserta ID nya, maka pertama diinisialisasikan terlebih dahulu ```max_profit=0``` dan  ```id=0```
```
awk -F '\t' 'BEGIN{max_profit=0; id=0}
```
```-F '\t'``` berguna untuk membatasi input dengan tab. 

Kemudian untuk perhitungan persentase profit serta pengecekan per barisnya dilakukan :
```
profit=($21/($18-$21))*100; 
if(NR>1 && profit>=max_profit) {max_profit=profit; id=$1}
```
Pada setiap baris kecuali baris pertama akan dihitung jumlah persentase profitnya dengan persamaan ```profit=($21/($18-$21))*100``` dan kemudian nilainya dibandingkan dengan ```max_profit```. Nilai dari ```max_profit``` akan bernilai sama dengan hasil perhitungan persentase profit pada record tertentu ketika nilainya lebih kecil atau sama dengan dari ```profit``` record tersebut. Dan juga ketika memenuhi kondisi seperti itu maka ```id``` akan diambil dari kolom 1 record tersebut.

Lalu pada akhirnya diberikan rule ```END``` dan hasil dari outputnya dimasukkan ke dalam ```hasil.txt``` :
```
END{
	printf "Transaksi terakhir dengan profit percentage terbesar yaitu ID %d dengan persentase %.2f%%\n", id, max_profit
	}' Laporan-TokoShiSop.tsv > hasil.txt
```
Digunakan operator redirect ```>``` yang berguna untuk membuat file baru ketika file belum ada atau menimpa isi dari file ketika filenya sudah ada.

### 2.b
Pertama diberikan rule ```BEGIN``` yang berisi insdtruksi soal :
```
awk -F '\t' 'BEGIN{print "\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:"} 
```

Karena yang diminta adalah nama-nama Customer yang melakukan transaksi pada tahun 2017 di Albuquerque, maka diberikan :
```
$3 ~ /..-..-17/ {if(NR>1 && $10=="Albuquerque") a[$7]++}
```
```$3 ~ /..-..-17/``` berguna untuk memfilter tahun **2017** yang berada pada field ke-3(waktu transaksi). Juga diberikan kondisi ketika ```$10=="Albuquerque"``` yang berguna untuk mendapatkan record berisikan **Albuquerque** pada field ke-10(kota). 
Jika suatu record memenuhi kondisi tersebut, maka nama kostumer akan disimpan pada array ```a[]```.

Selanjutnya akan diprint nama-nama yang melakukan transaksi pada tahun 2017 dan berada di Albuquerque:
```
END{for(b in a) print b}' Laporan-TokoShiSop.tsv >> hasil.txt
```
Pengulangan diatas berfungsi untuk menampilkan nama-nama customer yang telah tersimpan dalam array sebanyak 1 kali saja. Dan kemudian hasil dari outputnya ditambahkan ke dalam ```hasil.txt``` dengan menggunakan operator ```>>``` agar dapat menambahkan isi ke dalam file yang sudah ada.

### 2.c
Untuk menghitung banyak dari setiap **segment** dan menampilkan jumlahnya maka pertama-tama dapat dilakukan inisialisasi :
```
awk -F '\t' 'BEGIN{segment[0]=0; segment[1]=0; segment[2]=0; min=10000; seg=0; name="string"} 
```
setiap **segment** diinisialisasikan sebagai array ```segment[]``` dimana masing-masing bernilai 0. Juga diinisialisasikan ```min=10000``` sebagai variabel yang nantinya untuk membandingkan jumlah paling sedikit pada suatu segment, ```seg``` adalah variabel untuk mendapatkan index segment dan ```name="string"``` yang nantinya untuk mengoutputkan nama dari segment.

Setiap baris akan dicek pada field ke-8 yang berisikan record dari **segment** dan kemudian jumlah segment-segment tersebut akan bertambah setiap kali ditemukan. Dengan menggunakan :
```
if(NR!=1)
	{
	if($8 == "Consumer") segment[0]+=1; 
	if($8 == "Corporate") segment[1]+=1; 
	if($8 == "Home Office") segment[2]+=1;
	}
```

Kemudian jumlah yang telah didapatkan dari setiap **segment** akan dibandingkan untuk mencari segment mana yang jumlahnya paling sedikit :
```
for(i=0; i<3; i++){
	if(min>segment[i]){min=segment[i]; seg=i}
   	} 
```
Setelah didapatkan nilai ```min``` dengan jumlah segment paling sedikit, maka **index** dari segment tersebut dimasukkan ke dalam variabel ```seg```. 

Dan kemudian dilakukan inisialisasi nama dari index-index segment tersebut :
```
if(seg==0) name="Consumer"; 
if(seg==1) name="Corporate"; 
if(seg==2) name="Home Office"; 
```

Pada akhirnya dioutputkan hasilnya dan ditambahkan ke dalam file ```hasil.txt``` sesuai dari permintaan soal
```
printf "\nTipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi\n", name,min}' 
Laporan-TokoShiSop.tsv >> hasil.txt
```

### 2.d
Untuk menghitung total profit dari setiap **region** dan menampilkan jumlahnya maka pertama-tama dapat dilakukan inisialisasi :
```
awk -F '\t' 'BEGIN
{region[0]=0; region[1]=0; region[2]=0; region[3]=0; min_profit=10000000; reg=0; name="string"}
```
setiap **region** diinisialisasikan sebagai array ```region[]``` dimana masing-masing bernilai 0. Juga diinisialisasikan ```min_profit=10000000``` sebagai variabel yang nantinya untuk membandingkan jumlah profit paling sedikit pada tiap-tiap region, ```reg``` adalah variabel untuk mendapatkan index region dan ```name="string"``` yang nantinya untuk mengoutputkan nama dari region.

Setiap baris akan dicek pada field ke-13 yang berisikan record dari **region** dan kemudian isi dari arraynya akan terus ditambah sebesar nilai profit yang ada pada field ke-21. Dengan menggunakan :
```
NR>1{
	if($13 == "Central") region[0]+=$21; 
	if($13 == "East") region[1]+=$21; 
	if($13 == "South") region[2]+=$21; 
	if($13 == "West") region[3]+=$21;
} 
```

Kemudian jumlah profit yang telah didapatkan dari setiap **region** akan dibandingkan untuk mencari region mana yang jumlah profitnya paling sedikit :
```
for(i=0; i<4; i++){
	if(min_profit>region[i]){min_profit=region[i]; reg=i}
   	} 
```
Setelah didapatkan nilai ```min_profit``` dengan jumlah profit region yang paling sedikit, maka **index** dari region tersebut dimasukkan ke dalam variabel ```reg```. 

Dan kemudian dilakukan inisialisasi nama dari index-index region tersebut :
```
if(reg==0) name="Central"; 
if(reg==1) name="East"; 
if(reg==2) name="South"; 
if(reg==3) name="West";
```

Pada akhirnya dioutputkan hasilnya dan ditambahkan ke dalam file ```hasil.txt``` sesuai dari permintaan soal
```
printf "\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.4f\n", name, min_profit}' 
Laporan-TokoShiSop.tsv >> hasil.txt
```

## 2.e
Agar hasil dari laporan yang diminta mudah dibaca maka semua script dari poin **2.a** hingga **2.d** dijadikan satu di dalam file dengan format nama ```soal2_generate_laporan_ihir_shisop.sh```

## Soal No.3
Kuuhaku adalah orang yang sangat suka mengoleksi foto-foto digital, namun Kuuhaku juga merupakan seorang yang pemalas sehingga ia tidak ingin repot-repot mencari foto, selain itu ia juga seorang pemalu, sehingga ia tidak ingin ada orang yang melihat koleksinya tersebut, sayangnya ia memiliki teman bernama Steven yang memiliki rasa kepo yang luar biasa. Kuuhaku pun memiliki ide agar Steven tidak bisa melihat koleksinya, serta untuk mempermudah hidupnya, yaitu dengan meminta bantuan kalian. Idenya adalah :
### 3.a
Membuat script untuk **mengunduh** 23 gambar dari "https://loremflickr.com/320/240/kitten" serta **menyimpan** log-nya ke file "Foto.log". Karena gambar yang diunduh acak, ada kemungkinan gambar yang sama terunduh lebih dari sekali, oleh karena itu kalian harus **menghapus** gambar yang sama (tidak perlu mengunduh gambar lagi untuk menggantinya). Kemudian **menyimpan** gambar-gambar tersebut dengan nama "Koleksi_XX" dengan nomor yang berurutan **tanpa ada nomor yang hilang** (contoh : Koleksi_01, Koleksi_02, ...)
### 3.b
Karena Kuuhaku malas untuk menjalankan script tersebut secara manual, ia juga meminta kalian untuk menjalankan script tersebut **sehari sekali pada jam 8 malam** untuk tanggal-tanggal tertentu setiap bulan, yaitu dari **tanggal 1 tujuh hari sekali** (1,8,...), serta dari **tanggal 2 empat hari sekali** (2,6,...). Supaya lebih rapi, gambar yang telah diunduh beserta **log-nya, dipindahkan ke folder** dengan nama **tanggal unduhnya** dengan **format** "DD-MM-YYYY" (contoh : "13-03-2023").
### 3.c
Agar kuuhaku tidak bosan dengan gambar anak kucing, ia juga memintamu untuk **mengunduh** gambar kelinci dari "https://loremflickr.com/320/240/bunny". Kuuhaku memintamu mengunduh gambar kucing dan kelinci secara **bergantian** (yang pertama bebas. contoh : tanggal 30 kucing > tanggal 31 kelinci > tanggal 1 kucing > ... ). Untuk membedakan folder yang berisi gambar kucing dan gambar kelinci, **nama folder diberi awalan** "Kucing_" atau "Kelinci_" (contoh : "Kucing_13-03-2023").
### 3.d
Untuk mengamankan koleksi Foto dari Steven, Kuuhaku memintamu untuk membuat script yang akan **memindahkan seluruh folder ke zip** yang diberi nama “Koleksi.zip” dan **mengunci** zip tersebut dengan **password** berupa tanggal saat ini dengan format "MMDDYYYY" (contoh : “03032003”).
### 3.e
Karena kuuhaku hanya bertemu Steven pada saat kuliah saja, yaitu setiap hari kecuali sabtu dan minggu, dari jam 7 pagi sampai 6 sore, ia memintamu untuk membuat koleksinya **ter-zip** saat kuliah saja, selain dari waktu yang disebutkan, ia ingin koleksinya **ter-unzip** dan **tidak ada file zip** sama sekali.

**Catatan :**
- Gunakan bash, AWK, dan command pendukung
- Tuliskan semua cron yang kalian pakai ke file cron3[b/e].tab yang sesuai


## Penyelesaian No.3 :
### 3.a
Pada mulanya, dengan memakai command `wget`, gambar diambil dengan nama menggunakan nama yang terpasang di server atau memakai `--trust-server-names`. Hal ini dilakukan dengan perulangan `for` sebanyak 23 kali. Tidak lupa untuk membuat `Foto.log` dengan menambahkan `-a` pada wget agar melakukan append isi ke log.
```
for i in {1..23}
do
	wget --trust-server-names -a "Foto.log" $1
done
```
Note: `$1` dikarenakan nantinya akan diaplikasikan kepada fungsi tersendiri yang memberikan isian pada `$1` berupa url.

Setelahnya dilakukan pembagian gambar, antara gambar yang ternyata duplikat berdasarkan dari server maupun gambar aslinya. Gambar duplikat dari server biasanya akan otomatis memiliki format `*.jpg.x` dengan x berupa angka.
```
img_array=($(ls *.jpg))
img_array_duplicate=($(ls *.jpg.*))
```

Perlakuan lantas dibagi dua. Apabila gambar berasal dari duplikat yang terdeteksi maka dilakukan penghapusan pada `img_array_duplicate`.
```
for i in "${img_array_duplicate[@]}"
do
	rm $i
done
```

Apabila di dalam gambar dengan format `*.jpg` ternyata masih ada yang sama, maka dilakukan `cmp` terhadap kedua gambar.
```
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
```

Lakukan kembali, pencarian gambar pasca dihapus yang selanjutnya dilakukan pergantian nama sesuai angkanya apakah di bawah 9 atau tidak. Dipakailah command mv.
```
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
```

Pada praktik di sini, seluruh cara tersebut dijadikan satu dalam sebuah fungsi dengan nama `download_move_data` dengan mengambil satu argumen url link. Hal ini hanya untuk memudahkan *debugging*.

### 3.b
Pada tahap ini, semua langkah hampir sama dengan proses pada 3.a. Namun, dilakukan perubahan pada line akhir dari fungsi. Karena terdapat formatting nama yang berdasarkan `date` dengan bentuk "DD-MM-YY". Lantas, hasil date tersebut dibuatkan directory baru dengan `mkdir`.
```
foldername=($(date "+%d-%m-%Y"))
mkdir "$foldername"
```

Lantas, kita memasukkan seluruh gambar dan `Foto.log` ke folder tersebut. Program ini dimasukkan ke fungsi `collected_data` dengan argumen 1 adalah `$foldername`.
```
collected_data(){
    img_array=($(ls *.jpg))
    mv "Foto.log" "$1/Foto.log"
    for i in "${!img_array[@]}"
    do
        mv "${img_array[$i]}" "$1/${img_array[$i]}"
    done
}
```
Lantas, tinggal memanggil `collected_data $foldername`.

Jika sudah selesai dibuat, dilakukan pembuatan cron job dengan menekan `crontab -e` pada terminal dan menambahkan isian berikut.
```
0 20 1-31/7,2-31/4 * * cd /home/wisnupramoedya/Programming/Bash/modul-1/soal-shift-sisop-modul-1-E01-2021/soal3 && bash soal3b.sh
```
Catatan:
- Pengaturan `0 20 1-31/7,2-31/4 * *` ini berarti terbatas pada jam 20:00 dengan dijalankan pada tanggal 1-31 untuk tujuh hari sekali dan 2-31 untuk empat hari sekali.
- Command cd dst hanya menunjukkan untuk mengarahkan directory ke tempat file.

### 3.c
Untuk tahap ini, karena sebelumnya sudah dibuatkan fungsi. Mulanya kita cukup mendefinisikan constant kita.
```
URL_KUCING="https://loremflickr.com/320/240/kitten"
URL_KELINCI="https://loremflickr.com/320/240/bunny"

FOLDERNAME_KUCING="Kucing_"
FOLDERNAME_KELINCI="Kelinci_"
```

Untuk menentukan url atau hewan apa yang harus dilakukan pendownloadan, dibuatkan pendeteksi jumlah folder `Kucing_*` dan `Kelinci_*` dengan `ls -d jenis_folder_* | wc -l`. `ls` untuk menyebutkan seluruh file, sedangkan `wc` untuk menghitung banyak list. Yang selanjutnya, dilakukan pemilihan, jika jumlah folder kucing apakah kurang dari kelinci. Hal ini bermaksud untuk asumsi untuk selalu bergantian jika dijalankan. Ke seluruh perjalanan tersebut dimasukkan ke fungsi `counter_ls`.
```
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
```

Selanjutnya, cek counter `kucing` yang telah dibuat apakah sekarang saatnya mendownload kucing atau kelinci.
```
if [[ $kucing -eq 1 ]]
then
    download_move_data $URL_KUCING $FOLDERNAME_KUCING
else
    download_move_data $URL_KELINCI $FOLDERNAME_KELINCI
fi
```

Cara yang dipakai pada tahap ini hampir sama dengan soal 3.c, namun perbedaannya adalah berikut.
1. Fungsi download_move_data mengambil dua argumen. Yang pertama adalah url sumber. Yang kedua adalah jenis folder. Berikut contohnya.
```
download_move_data $URL_KELINCI $FOLDERNAME_KELINCI
```
2. Nama folder dibuatkan sebuah fungsi baru.
Fungsi ini akan mencoba untuk mengambil date dengan format DD-MM-YY. Lantas, string date yang sudah dibuat digabungkan dengan jenis_folder. Argumen yang diambil fungsi ini adalah jenis folder. Sehingga, jika dijalankan seperti ini `foldername=$(foldername_generate $2)`. Namun bentukan fungsi adalah berikut.
```
foldername_generate(){
    local str=($(date "+%d-%m-%Y"))
    echo "$1$str"
}
```
Setelahnya, keseluruhan bentukannya sama yakni memasukkan file ke foldername yang telah dibuat sebagaimana soal 3.b.

### 3.d
Pada tahap ini, dilakukan pengecekan terhadap banyak jumlah folder `Kelinci_*` dan `Kucing_*`. Di sini digunakan `ls -d Kelinci_* Kucing_*` yang selanjutnya dilakukan pipe ke `awk 'END {print NR}'`.

Hasil yang didapat dari awk lantas dijadikan acuan ke dalam if else. Di dalam if else, mulanya dibuatkan format password dengan bentuk MMDDYY. Pembuatan password dengan `date` adalah berikut.
```
PASSWORD=($(date "+%m%d%Y"))
```
Dari password yang sudah dibuat, dimasukkanlah ke dalam command `zip` dengan argumen yang dimasukkan seperti `-p` (setelahnya dimasukkan `$PASSWORD`) serta `-r` agar rekursif ke dalam setiap subfolder (setelahnya dimasukkan tiga argumen, yakni Koleksi.zip, `Kucing_*`, dan `Kelinci_*`). Setelahnya, kita lakukan delete terhadap seluruh folder `Kucing_*` dan `Kelinci_*` dengan `rm` sebagai berikut.
```
PASSWORD=($(date "+%m%d%Y"))
zip -P $PASSWORD -r Koleksi.zip Kucing_* Kelinci_* && rm -r Kucing_* Kelinci_*
```

Secara keseluruhan hasil dari soal3d.sh adalah berikut.
```
if [[ ($(ls -d Kelinci_* Kucing_* | awk 'END {print NR}')) ]];
then
    PASSWORD=($(date "+%m%d%Y"))
    zip -P $PASSWORD -r Koleksi.zip Kucing_* Kelinci_* && rm -r Kucing_* Kelinci_*
fi
```

### 3.e
Untuk membatasi file dalam keadaan zip hanya saat kuliah. Maka kita menjalankan script `soal3d.sh` pada crontab sebagai berikut.
```
* 7-18 * * 1-5 cd /home/wisnupramoedya/Programming/Bash/modul-1/soal-shift-sisop-modul-1-E01-2021/soal3 && bash soal3d.sh
```
Catatan:
- \* 7-18 * * 1-5 berarti menjalankan pada hari Senin hingga Jumat pada pukul 7 pagi hingga 6 sore setiap menit (asumsi jika laptop tidak dinyalakan setiap hari maka perlu setiap menit)

Sedangkan untuk mengunzip file di luar kuliah maka dibutuhkan fungsi khusus di dalam crontab.

Karena zip terpassword dengan format MMDDYY, maka perlu dicari nilai kapan zip tersebut dibuat. Di sini, dapat dipakai command `stat` untuk mendapatkan kapan Koleksi.zip terakhir diedit dengan `"%y"` (karena pembuatan sudah pasti sama dengan terakhir diedit sebab tidak mungkin zip di tengah-tengah). Sehingga, scriptnya dengan mencoba memasukkan ke variabel `modif_date` sebagai berikut.
```
modif_date=$(stat --format="%y" Koleksi.zip)
```
Setelahnya, dilakukan passing `$modif_date` ke command `date` agar didapatkan format MMDDYY.
```
pass_date=$(date -d "$modif_date" "+%m%d%Y")
```
Dari password yang sudah dibuat, dimasukkanlah ke dalam command `unzip` dengan argumen yang dimasukkan seperti `-p` (setelahnya dimasukkan `$pass_date`) serta nama zip `Koleksi.zip`. Setelah selesai di-unzip, kita lakukan delete terhadap zip `Koleksi.zip` dengan `rm` sebagai berikut.
```
unzip -P $pass_date Koleksi.zip; rm Koleksi.zip;
```

Sehingga, dengan tidak lupa menambahkan `;` pada akhiran bash line serta mengubah `%` menjadi `\%`, pada crontab menjadi berikut.
```
* 0-6,18-23 * * 1-5 cd /home/wisnupramoedya/Programming/Bash/modul-1/soal-shift-sisop-modul-1-E01-2021/soal3 && modif_date=$(stat --format="\%y" Koleksi.zip); pass_date=$(date -d "$modif_date" "+\%m\%d\%Y"); unzip -P $pass_date Koleksi.zip; rm Koleksi.zip;
* * * * 0,6 cd /home/wisnupramoedya/Programming/Bash/modul-1/soal-shift-sisop-modul-1-E01-2021/soal3 && modif_date=$(stat --format="\%y" Koleksi.zip); pass_date=$(date -d "$modif_date" "+\%m\%d\%Y"); unzip -P $pass_date Koleksi.zip; rm Koleksi.zip;
```
Catatan:
1. Fungsi pertama `* 0-6,18-23 * * 1-5` berfungsi pada hari kuliah. Yakni diunzip saat hari Senin sampai Jumat pada pukul 0 hingga 7 (cukup dibikin 6 karena setiap menit dari 6:00 hingga 6:59) serta 18 sampai 24 pada setiap menitnya.
2. Fungsi kedua `* * * * 0,6` berfungsi saat hari libur yakni pada Minggu dan Sabtu di mana dijalankan setiap saat.

## Kendala
- Regex harus cari-cari sendiri, tidak ada di modul
- Penggunaan crontab ternyata terbatas pada beberapa sifat khusus seperti `%`
