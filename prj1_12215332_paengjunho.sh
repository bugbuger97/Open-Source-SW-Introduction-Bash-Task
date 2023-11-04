#! /bin/bash
item=$1
data=$2
user=$3
echo "--------------------------"
echo "User Name: $(whoami)"
echo "Student Number: 12215332"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"
while true
do
    echo
    read -p "Enter your choice [ 1-9 ] " choice
    if [ $choice = 1 ]; then
        echo
        read -p "Please enter 'movie id' (1~1682):" movie_id
        awk -v line="$movie_id" 'NR==line' $item
    elif [ $choice = 2 ]; then
       echo
       read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n):" intention
       if [ $intention = "y" ]; then
            echo
            awk -F'|' '$7 {print $1, $2}' $item | sort -n | head -n 10
        else
            continue
        fi
    elif [ $choice = 3 ]; then
        echo
        read -p "Please enter the 'movie id' (1~1682):" input_movie_id
        count=0
        rating_sum=0
        while read -r user_id movie_id rating timestamp; do
            if [ "$movie_id" -eq "$input_movie_id" ]; then
                count=$((count + 1))
                rating_sum=$((rating_sum + rating))
            fi
        done < $data
        result=$(echo "scale=6; $rating_sum / $count" | bc)
        result=$(printf "%.5f" $result)
        echo
        echo "average rating of $input_movie_id: $result"
    elif [ $choice = 4 ]; then
        echo
        read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n):" intention
        if [ $intention = "y" ]; then
            echo
            awk -F'|' '{ for(i = 1; i <= NF; i++) { 
if(i != 5) { printf "%s",$i; if(i < NF) printf "|" } 
else { printf "|" }} print"" }' $item | head -n 10
        else
            continue
        fi
    elif [ $choice = 5 ]; then
        echo
        read -p "Do you want to get the data about users from 'u.user'? (y/n):" intention
        if [ $intention = "y" ]; then
            echo
            awk -F'|' '{if($3 == "M") {$3 = "male"} else {$3 = "female"}} {print "user",$1,"is",$2,"years old",$3,$4}' $user | head -n 10
        else
            continue
        fi
    elif [ $choice = 6 ]; then
        echo
        read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):" intention
        if [ $intention = "y" ]; then
            echo
            awk -F'|' '{
gsub("-","",$3); 
gsub("Jan","01",$3); 
gsub("Feb","02",$3); 
gsub("Mar","03",$3);
gsub("Apr","04",$3); 
gsub("May","05",$3); 
gsub("Jun","06",$3); 
gsub("Jul","07",$3); 
gsub("Aug","08",$3); 
gsub("Sep","09",$3); 
gsub("Oct","10",$3); 
gsub("Nov","11",$3); 
gsub("Dec","12",$3); 
$3 = substr($3,5,4) substr($3,3,2) substr($3,1,2); 
for(i = 1; i <= NF; i++) { printf "%s",$i; if(i < NF) printf "|" } print ""}' $item | tail -n 10
        else
            continue
        fi
    elif [ $choice = 7 ]; then
        echo
        read -p "Please enter the 'user id' (1~943):" input_user_id
        echo
        find_movie_id=$(awk -v user_id="$input_user_id" -F' ' '$1 == user_id {print $2}' "$data" | sort -n | tr '\n' '|' | sed 's/|$//')
        echo $find_movie_id
        echo
        IFS='|' read -ra movie_id_array <<< "$find_movie_id"
        for((i=0;i<10;i++)); do
            awk -v movie_id="${movie_id_array[i]}" -F'|' '$1 == movie_id {printf "%s|%s\n", $1,$2}' "$item"
        done
    elif [ $choice = 8 ]; then
        echo
        read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" intention
        if [ $intention = "y" ]; then
            echo
            find_user_id=$(awk -F'|' '$2 >= 20 && $2 <= 29 && $4 == "programmer" {print $1;}' $user | sort -n)
            touch condensed_data_1.txt
            touch condensed_data_2.txt
            touch condensed_data_3.txt
            for i in ${find_user_id}; do
                awk -v user_id="$i" -F' ' '($1 == user_id) {print int($2),int($3)}' "$data" >> condensed_data_1.txt
            done
            awk -F' ' '{key=$1; sum[key]+=$2; count[key]++;} END {for(key in sum) {print key, sum[key], count[key];}}' condensed_data_1.txt >> condensed_data_2.txt
            awk -F' ' '{key=$1; if($2 > max[key]){max[key]=$2; line[key]=$0;}} END {for(key in max){print line[key];}}' condensed_data_2.txt |sort -n > condensed_data_3.txt 
            awk -F' ' '{
average = $2 / $3 ;
if(average == int(average)) {printf "%d %d\n",$1,int(average)} 
else {
average = sprintf("%.5f",average);
sub(/\.?0+$/, "", average);
printf "%d %s\n", $1, average;}}' condensed_data_3.txt
            rm condensed_data_1.txt
            rm condensed_data_2.txt
            rm condensed_data_3.txt
        else
            continue
        fi
    elif [ $choice = 9 ]; then
        echo "Bye!"
        exit
    else 
        continue
    fi  
done    
