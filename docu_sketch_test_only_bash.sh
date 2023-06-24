#!/bin/bash

# проверка наличия первого аргумента (номера порта)
argument_1="$1"

if [ -z "$argument_1" ]
then
    port=8080
else
    # в случае когда первый аргумент командной строки не является пустым,
	# выполняется проверка, является ли первый аргумент числом
	# (то есть передаётся ли номер порта или же номер порта не задан
	#  и передаётся только имя человека для приветствия)
	if [[ "$argument_1" =~ ^[0-9]+$ ]]
	then
	  echo "1-й аргумент командной строки является номером порта"
	  port=$argument_1
	  # получение имён людей из аргументов командной строки, передаваемых в bash-скрипт
	  # команда 'shift' сдвигает все аргументы командной строки влево, пропуская 1-ый аргумент;
	  # в данном случае она используется для пропуска 1-го аргумента, который считается номером порта
	  # (так делается для того, чтобы в массив 'names' попали только имена людей,
	  #  а 1-ый аргумент с номером порта был исключен из списка)
	  shift
	else
	  echo "1-й аргумент командной строки не содержит номер порта"
	  port=8080
	fi
fi

# получение имён людей из аргументов командной строки, передаваемых в bash-скрипт
# приведённая ниже команда создает массив 'names' и заполняет его значениями аргументов командной строки
# "$@" - специальная переменная, которая раскрывается в список всех аргументов командной строки
# знак "$" гарантирует правильную обработку аргументов, содержащих пробелы или специальные символы
names=("$@")

# определяем количество переданных в bash-скрипт имён
count=${#names[@]}
echo "Number of names in the list: $count"

# генерация содержимого файла 'index.html'
html_content="<html>Hello, people!:)<br><br><body>"

# 1-й вариант с поимённым приветствием
#if [ "$count" != 0 ] 
#then
#    for name in "${names[@]}"
#    do
#	  if [ "$count" == 1 ]
#      then
#        html_content+="$name, hello!"
#      else
#	    html_content+="$name, "
#		html_content+="hello!"
#	  fi
#    done
#fi

# 2-й вариант с одновременным приветствием всех людей,
# чьи имена переданы в качестве аргументов командной строки
if [ "$count" != 0 ]
  then
    for ((i=0; i<count; i++))
	  do
        if [ "$i" -eq $((count-1)) ]
		then
          html_content+="${names[$i]}, hello!"
        else
          html_content+="${names[$i]}, "
        fi
      done
fi

# добавляем mem в html-контент 
html_content+="<img src=\"cloud.jpg\"></body></html>"

# создание файла 'index.html'
echo "$html_content" > index.html

# копирование mem'а в рабочую директорию
path_to_mem="/mnt/c/Users/saifs/Pictures/Saved Pictures/cloud.jpg"
cp "$path_to_mem" .

# создание Dockerfile
cat > Dockerfile <<EOF
FROM nginx
COPY index.html /usr/share/nginx/html
COPY cloud.jpg /usr/share/nginx/html
EOF

# сборка docker image'а
docker build -t hello_people .

# запуск контейнера из собранного образа 'hello_people' на определённом порту
docker run -p "$port":80 -it hello_people
