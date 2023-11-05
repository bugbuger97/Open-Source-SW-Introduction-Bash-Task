Open-Source-SW-Introduction-Bash-Task

인하대 오픈소스 SW 개론 Bash 과제입니다.

커맨드 : bash prj1_12215332_paengjunho.sh u.item u.data u.user
              
#! /bin/bash -> 스크립트가 Bash를 사용하여 실행됨.

스크립트 실행 시 전달된 인수를 변수에 할당함.
$1, $2, $3은 스크립트를 실행할 때, 전달된 인수를 나타냄.
$1 <- u.item을 나타냄.
$2 <- u.data를 나타냄.
$3 <- u.user를 나타냄.

item=$1  
data=$2  
user=$3


과제 pdf의 형식을 echo를 사용하여 나타냄.
echo "--------------------------"
현재 사용자 이름을 출력함.
echo "User Name: $(whoami)" 
학번을 출력함.
echo "Student Number: 12215332" 

형식에 맞춰서 메뉴 항목을 화면에 출력함.
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

# 무한 loop를 while문을 통해 실행
무한 루프를 통해 사용자의 선택을 반복적으로 처리합니다.
while true
do
    
    # 과제 형식에 맞추기 위해 echo를 사용함
    
    echo 
    
    # 메뉴 형식에 맞춰서 사용자가 1번에서 9번중 선택을 입력 해야함.
    
    read -p "Enter your choice [ 1-9 ] " choice

    # 사용자가 메뉴 1번을 선택함 -> 1번 : 사용자가 1~1682 사이에 있는 번호를 입력하면 u.item에 있는 파일안에서 movie id와 같은 번호를 매칭하여 그 줄을 출력함.
    if [ $choice = 1 ]; then
        echo
        read -p "Please enter 'movie id' (1~1682):" movie_id
        awk -v line="$movie_id" 'NR==line' $item

    # 사용자가 메뉴 2번을 선택함 -> 2번 : 사용자가 의사표시를 yes로 표현하면 u.item 파일에서 장르가 action에 해당하는 $1(영화 ID)와 $2(영화 제목)을 출력함.
    # 사용자로부터 액션 장르 영화 데이터를 출력할 지 묻고, 사용자가 'y'를 선택한 경우 해당 데이터를 출력함.
    elif [ $choice = 2 ]; then
       echo
       read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n):" intention
       # 만약 의사가 yes라면
       if [ $intention = "y" ]; then
            echo
            # $7(action genre)에 해당하는 영화 ID와 영화 제목을 영화 ID를 기준으로 오름차순 정렬하고 그 중 위의 10개를 출력함.
            awk -F'|' '$7 {print $1, $2}' $item | sort -n | head -n 10 
        # 의사가 yes가 아니면 메뉴 선택문으로 다시 돌아감.
        else
            continue
        fi
    # 사용자가 메뉴 3번을 선택함 -> 3번 : 사용자가 영화 ID를 입력하면 u.data 파일에 있는 열을 읽어서 평균 평점을 구하도록 함.   
    elif [ $choice = 3 ]; then
        echo
        read -p "Please enter the 'movie id' (1~1682):" input_movie_id
        # 변수 count -> 영화 평점의 개수
        count=0
        # 변수 rating_sum -> 영화의 모든 평점들의 합
        rating_sum=0
        # u.data 파일안의 열들을 각 변수에 읽어들임.
        while read -r user_id movie_id rating timestamp; do
            # 만약 사용자가 입력한 영화 ID와 u.data안의 영화 ID가 같으면 변수 count 1씩 증가, u.data안의 영화 평점을 변수 rationg_sum에 계속해서 합함.
            if [ "$movie_id" -eq "$input_movie_id" ]; then
                count=$((count + 1))
                rating_sum=$((rating_sum + rating))
            fi
        # u.data에서 불러옴
        done < $data
        # sclae=6 -> bc에서 출력되는 소수점 이하의 자릿수를 6자리로 제한하는 것을 나타냄. 
        # bc는 입력된 수식을 계산하고 결과를 출력하는 계산기 도구
        result=$(echo "scale=6; $rating_sum / $count" | bc)
        # 변수 result가 소수점 6번째 자리 표현된 것을 반올림하여 소수점 5번째로 만들어서 다시 변수 result에 넣는다. 
        result=$(printf "%.5f" $result)
        echo
        # 메뉴 3번 형식에 맞춰서 평균 평점 출력
        echo "average rating of $input_movie_id: $result"

    # 사용자가 메뉴 4번을 선택함 -> 4번 : u.item 파일에서 $5(IMDb URL)를 제거하고 상위 10개를 출력함.    
    elif [ $choice = 4 ]; then
        echo
        read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n):" intention
        # 만약 사용자 의사 표시가 yes라면 
        if [ $intention = "y" ]; then
            echo
            # u.item 파일 안에 구분자 '|'로 열들이 구분되어 있는데 '|'을 제거하면서 열들을 읽음.
            # for문을 이용하여 만약 $5(IMDb URL) 내용이 아니면 정보를 출력하고 사이 사이에 '|'을 넣도록 함.
            # IMDb URL의 내용이 들어오면 '|' 구분자로 출력함.
            awk -F'|' '{ for(i = 1; i <= NF; i++) { 
                if(i != 5) { printf "%s",$i; if(i < NF) printf "|" } 
                else { printf "|" }} print"" }' $item | head -n 10
        else
            continue
        fi

    # 사용자가 5번을 선택함 -> 5번 : 사용자로부터 사용자 데이터를 출력할 지 묻고, 사용자가 'y'를 선택한 경우 u.user파일 안에서 gender의 M -> male, F -> female로 바꿔서 출력함.
    elif [ $choice = 5 ]; then
        echo
        read -p "Do you want to get the data about users from 'u.user'? (y/n):" intention
        if [ $intention = "y" ]; then
            echo
            # u.user파일안에서 '|' 구분자들을 지우고 열들에 맞춰서 정보를 읽어들인다 -> $3(gender)을 읽어 들여서 M이면 mele, F이면 female로 바꿔서 형식에 맞춰서 상위 10개 출력함.
            awk -F'|' '{if($3 == "M") {$3 = "male"} else {$3 = "female"}} {print "user",$1,"is",$2,"years old",$3,$4}' $user | head -n 10
        else
            continue
        fi

    # 사용자가 6번을 선택함 -> 6번 : 사용자로부터 출시 날짜 형식을 수정할 지 묻고, 사용자가 'y'를 선택한 경우, u.item에 있는 날짜 형식을 우리가 아는 날짜 형식으로 바꿔서 출력함.
    elif [ $choice = 6 ]; then
        echo
        read -p "Do you want to Modify the format of 'release date' in 'u.item'?(y/n):" intention
        if [ $intention = "y" ]; then
            echo
            # u.item 파일에서 $3(날짜 형식)을 읽어서 gsub명령어를 이용해서 "-"를 없애고 각 영어로 되어있는 1 ~ 12월을 숫자 형식의 문자열로 바꿈.
            # substr(문자열, 시작 위치, 길이) -> 특정 위치에서 시작하여 지정된 길이나 인덱스 범위 내의 문자열 부분을 추출함.
            # substr() 명령어를 이용하여 01011995있던 $3가 19950101로 재배치함.
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
                # 상위 
                for(i = 1; i <= NF; i++) { printf "%s",$i; if(i < NF) printf "|" } print ""}' $item | tail -n 10
        else
            continue
        fi
    # 사용자가 7번을 선택함 -> 7번 : 사용자로부터 사용자 ID를 입력받고, 해당 사용자가 평가한 영화 ID를 출력한 뒤, 해당하는 영화 제목 상위 10개의 목록을 출력함.
    elif [ $choice = 7 ]; then
        echo
        # 사용자가 사용자 ID를 입력함.
        read -p "Please enter the 'user id' (1~943):" input_user_id
        echo
        # u.data파일에서 입력한 사용자 ID와 일치하는 사용자 ID를 찾고 그와 같은 라인의 영화 ID를 출력하면서 영화 ID 사이 사이에 '|'을 출력함.
        find_movie_id=$(awk -v user_id="$input_user_id" -F' ' '$1 == user_id {print $2}' "$data" | sort -n | tr '\n' '|' | sed 's/|$//')
        echo $find_movie_id
        echo
        # 사용자가 본 영화 ID를 find_movie_id에 저장했는데 이것을 movie_id_array에 배열로 저장함.
        IFS='|' read -ra movie_id_array <<< "$find_movie_id"
        # 배열 요소 중 10개만 u.item파일안에서의 영화 ID와 일치하면 영화 ID와 영화 제목을 출력함 
        for((i=0;i<10;i++)); do
            awk -v movie_id="${movie_id_array[i]}" -F'|' '$1 == movie_id {printf "%s|%s\n", $1,$2}' "$item"
        done
    # 사용자가 8번을 선택함 -> 8번 : 20~29세이며 직업이 '프로그래머'인 사용자가 평가한 영화의 평균 평점을 계산하여 출력합니다.
    elif [ $choice = 8 ]; then
        echo
        read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" intention
        if [ $intention = "y" ]; then
            echo
            # 20~29세이며 직업이 '프로그래머'인 사용자 ID를 찾아서 변수 find_user_id에 저장함.
            find_user_id=$(awk -F'|' '$2 >= 20 && $2 <= 29 && $4 == "programmer" {print $1;}' $user | sort -n)
            # 추출해서 데이터를 정리하여 한꺼번에 연산할 위해 condensed_data_1.txt, condensed_data_2.txt, condensed_data_3.txt 생성함.
            touch condensed_data_1.txt
            touch condensed_data_2.txt
            touch condensed_data_3.txt
            # u.data파일에서 변수 find_user_id의 사용자 ID마다 본 영화 ID와 사용자가 평가한 영화 평점들을 condensed_data_1.txt에 저장함.
            # condensed_data_1.txt의 $1 = 영화 ID, $2 = 사용자가 평가한 영화 평점이 됨.
            for i in ${find_user_id}; do
                awk -v user_id="$i" -F' ' '($1 == user_id) {print int($2),int($3)}' "$data" >> condensed_data_1.txt
            done
            # condensed_data_1.txt에 있는 중복되는 영화 ID에 평점들의 합계와 중복되는 영화 개수를 세고 그 정보들을 condensed_data_2.txt에 저장함.
            # condensed_data_2.txt의 $1 = 영화 ID, $2 = 영화 평점 합계, $3 = 카운트가 됨.
            awk -F' ' '{key=$1; sum[key]+=$2; count[key]++;} END {for(key in sum) {print key, sum[key], count[key];}}' condensed_data_1.txt >> condensed_data_2.txt
            # condensed_data_2.txt에서 아직 중복 요소들이 그대로 남아있다.
            # $2(영화 평점 합계)를 기준으로 높은 것만 추출해서 오름차순으로 정렬해서 condensed_data_3.txt에 저장함.
            # condensed_data_3.txt의 $1 = 중복없는 영화 ID, $2 = 영화 평점 총합, $3 = 카운트가 됨. 
            awk -F' ' '{key=$1; if($2 > max[key]){max[key]=$2; line[key]=$0;}} END {for(key in max){print line[key];}}' condensed_data_2.txt |sort -n > condensed_data_3.txt
            # condensed_data_3.txt안에 $2(평점 합계)와 $3(카운트)를 한번에 나눠주면 평균 평점을 한번에 4초안에 출력할 수 있다.      
            # 이 부분에서는 0인 소수점을 제거하면서 출력하는 코드이다.
            # %.5f으로 소수점 아래 5자리까지 유지합니다.
            # 정규 표현식 \.?0+$를 사용하여 average 문자열에서 소수 부분에서 소수점 뒤에 0이 1개 이상 있는 경우 이를 제거함.
            awk -F' ' '{
average = sprintf("%.5f",$2 / $3);
sub(/\.?0+$/, "", average);
printf "%d %s\n", $1, average;}' condensed_data_3.txt 

            # 생성한 txt파일들 제거함.
            rm condensed_data_1.txt
            rm condensed_data_2.txt
            rm condensed_data_3.txt
        else
            continue
        fi
     # 사용자가 9번을 선택함 -> 9번 : 스크립트를 종료합니다.
    elif [ $choice = 9 ]; then
        echo "Bye!"
        exit
    else 
        continue
    fi  
done
