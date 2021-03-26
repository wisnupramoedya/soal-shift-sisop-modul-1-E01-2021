#!/bin/bash

awk -F '\t' 'BEGIN{max_profit=0; id=0} 
{
	profit=($21/($18-$21))*100; 
	if(NR>1 && profit>=max_profit) {max_profit=profit; id=$1} 
} END{printf "Transaksi terakhir dengan profit percentage terbesar yaitu ID %d dengan persentase %.2f%%\n", id, max_profit}' Laporan-TokoShiSop.tsv > hasil.txt

awk -F '\t' 'BEGIN{print "\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:"} $3 ~ /..-..-17/ {if(NR>1 && $10=="Albuquerque") print $7}' Laporan-TokoShiSop.tsv >> hasil.txt

awk -F '\t' 'BEGIN{segment[0]=0; segment[1]=0; segment[2]=0; min=10000; seg=0; name="string"} 
{if(NR!=1)
	{if($8 == "Consumer") segment[0]+=1; if($8 == "Corporate") segment[1]+=1; if($8 == "Home Office") segment[2]+=1;}
} 
END{for(i=0; i<3; i++){
	if(min>segment[i]){
		min=segment[i]; seg=i
		}
   	} 
if(seg==0) name="Consumer"; 
if(seg==1) name="Corporate"; 
if(seg==2) name="Home Office"; 
printf "\nTipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi\n", name,min}' Laporan-TokoShiSop.tsv >> hasil.txt

awk -F '\t' 'BEGIN{region[0]=0; region[1]=0; region[2]=0; region[3]=0; min_profit=10000000; reg=0; name="string"}
NR>1{
	if($13 == "Central") region[0]+=$21; if($13 == "East") region[1]+=$21; if($13 == "South") region[2]+=$21; if($13 == "West") region[3]+=$21;
} 
END{for(i=0; i<4; i++){
	if(min_profit>region[i]){
		min_profit=region[i]; reg=i
		}
   	} 
if(reg==0) name="Central"; 
if(reg==1) name="East"; 
if(reg==2) name="South"; 
if(reg==3) name="West";
printf "\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.4f\n", name, min_profit}' Laporan-TokoShiSop.tsv >> hasil.txt
