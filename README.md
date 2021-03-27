# soal-shift-sisop-modul-1-E01-2021
Sebagai tugas pengerjaan modul 1 SISOP E 2021.

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
	printf "Transaksi terakhir dengan profit percentage terbesar yaitu ID %d dengan persentase %.2f%%\n", id, max_profit}' Laporan-TokoShiSop.tsv > hasil.txt
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
	{if($8 == "Consumer") segment[0]+=1; if($8 == "Corporate") segment[1]+=1; if($8 == "Home Office") segment[2]+=1;}
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

Pada akhirnya dioutputkan hasilnya dan ditambahkan ke dalam file ```hasil.txt`` sesuai dari permintaan soal
```
printf "\nTipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi\n", name,min}' Laporan-TokoShiSop.tsv >> hasil.txt
```

## 2.d
Untuk menghitung total profit dari setiap **region** dan menampilkan jumlahnya maka pertama-tama dapat dilakukan inisialisasi :
```
awk -F '\t' 'BEGIN
{region[0]=0; region[1]=0; region[2]=0; region[3]=0; min_profit=10000000; reg=0; name="string"}
```
setiap **region** diinisialisasikan sebagai array ```region[]``` dimana masing-masing bernilai 0. Juga diinisialisasikan ```min_profit=10000000``` sebagai variabel yang nantinya untuk membandingkan jumlah profit paling sedikit pada tiap-tiap region, ```reg``` adalah variabel untuk mendapatkan index region dan ```name="string"``` yang nantinya untuk mengoutputkan nama dari region.

Setiap baris akan dicek pada field ke-13 yang berisikan record dari **region** dan kemudian isi dari arraynya akan terus ditambah sebesar nilai profit yang ada pada field ke-21. Dengan menggunakan :
```
NR>1{
	if($13 == "Central") region[0]+=$21; if($13 == "East") region[1]+=$21; if($13 == "South") region[2]+=$21; if($13 == "West") region[3]+=$21;
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

Pada akhirnya dioutputkan hasilnya dan ditambahkan ke dalam file ```hasil.txt`` sesuai dari permintaan soal
```
printf "\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.4f\n", name, min_profit}' Laporan-TokoShiSop.tsv >> hasil.txt
```

## 2.e
Agar hasil dari laporan yang diminta mudah dibaca maka semua script dari poin **2.a** hingga **2.d** dijadikan satu di dalam file dengan format nama ```soal2_generate_laporan_ihir_shisop.sh```
