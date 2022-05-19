#! /bin/bash


if [[  -z $1  ]]; then
	echo "Первый параметр размер, второй имя файла без расширения"
	return 0
else
	EXPORT_PATH="$(dirname "$PWD")"/png-$1;
	mkdir -p $EXPORT_PATH;
	echo $EXPORT_PATH
	for file in ${PWD}/${2}.svg 
	do
		echo 'Конвертация: '$filename
		filename=$(basename $file) 
		inkscape --export-filename=$EXPORT_PATH/${filename%.svg}.png -w $1 -h $1 $file
	done
fi

