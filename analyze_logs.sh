#!/bin/bash

input_file_name="access.log"
output_file_name="report.txt"
file_content="`cat $input_file_name`"

content="Отчет об логе сервера\n"
content+="=====================\n"

content+="Общее количество запросов:\t"
content+=`echo -e "$file_content" | awk '/^.+$/ { count++ } END { print count }'`

content+="\nКоличество уникальных IP-адресов:\t"
content+=`echo -e "$file_content" | awk '!U[$1]++{ count++ } END { print count }'`

content+="\n\nКоличество запросов по методам:\n\t"
content+=`echo -e "$file_content" | awk '{print $6}' |
awk '/^.GET$/ { count++ } END { print count, " GET" }'`

content+="\n\t"
content+=`echo -e "$file_content" | awk '{print $6}' |
awk '/^.POST/ { count++ } END { print count, " POST" }'`
content+="\n\n"

content+="Самый популярный URL:\t"
content+=`echo -e "$file_content" |
awk '{ urls[$7]++ } END { max = 0; for (url in urls) { if ( urls[url] > max ) { max = urls[url]; maxUrl = url; } } print max, maxUrl }'`

echo -e $content > "$output_file_name"
echo "Отчет сохранен в файл $output_file_name"