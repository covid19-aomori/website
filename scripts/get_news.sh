#!/bin/sh

# 接続先
URL="https://siftrss.com/f/eqMXvvMA8gR"

# 結果保存先ディレクトリ
DIR="."

# RSSを取得した時に一時保存するファイル名
RSS_XML="rss.xml"

# 次のタグと続く値を取得する
get_next_tag () {
  local IFS='>'
  read -d '<' TAG VALUE
}

#XMLを取得
curl -s -S $URL > $DIR/$RSS_XML

# お知らせ情報のリスト
declare -a ITEMS=()

while get_next_tag ; do
  # itemタグの始まりを検知
  REGEXP="item rdf:about=\"(.+)\?ref=rss\""
  if [[ $TAG =~ $REGEXP ]]; then
    URL=${BASH_REMATCH[1]}
    ITEM_FLAG=true
  fi

  # itemタグの中だけ、目的の値を取得
  if [ $ITEM_FLAG ]; then
    case $TAG in
      dc:date)
        REGEXP="([0-9]{4})-([0-9]{2})-([0-9]{2})JST.+"
        if [[ $VALUE =~ $REGEXP ]]; then
          DATE="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}/${BASH_REMATCH[3]}"
        fi
        ;;
      dc:subject)
        TEXT=$( echo $VALUE | nkf --numchar-input )
        ;;
      '/item')
        # 閉じタグ
        ITEM_FLAG=false
        ITEMS+=("{\"date\":\"${DATE}\",\"url\":\"${URL}\",\"text\":\"${TEXT}\"}")
        ;;
    esac
  fi
done < $DIR/$RSS_XML

# ソート（日付が文字列の最初の方にあるので、日付でソートされる）
IFS=$'\n'
ITEMS=($(echo "${ITEMS[*]}" | sort -r))

# 表示する件数
LENGTH=5

# jsonの出力
printf "{\n"
printf "\t\"newsItems\":[\n"

for (( i=0; i<LENGTH; i+=1 ))
do
     printf "\t\t${ITEMS[i]},\n"
done

# この一行は最後に固定で表示
printf "\t\t{\"date\":\"\",\"url\":\"https://www.pref.aomori.lg.jp/koho/coronavirus_index.html\",\"text\":\"その他、青森県からの新型コロナウイルス感染症についての情報はコチラ\"}"

printf "\n"
printf "\t]\n"
printf "}\n"

# 一時ファイルを削除
rm $DIR/$RSS_XML