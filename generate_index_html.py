#!/usr/bin/env python
# приведённая выше строка говорит операционной системе о том, что данный файл является исполняемым сценарием,
#  и для его выполнения необходимо использовать интерпретатор python, найденный в системе через команду 'env',
#  что позволяет запускать сценарий независимо от конкретного пути к интерпретатору python на различных системах

import sys

# получение имён людей из аргументов командной строки
names = sys.argv[1:]

# генерация содержимого файла 'index.html'
html_content="<html>Hello, people!:)<br><br><body>"

# вариант с одновременным приветствием всех людей,
# чьи имена переданы в качестве аргументов командной строки

# определение количества имен
count = len(names)

if count != 0:
    for i in range(count):
        if i == count-1:
            html_content += f"{names[i]}, hello!"
        else:
            html_content += f"{names[i]}, "

# добавляем mem в html-контент 
html_content+="<img src=\"cloud.jpg\"></body></html>"

# создание файла 'index.html'
with open("index.html", "w") as file:
    file.write(html_content)
