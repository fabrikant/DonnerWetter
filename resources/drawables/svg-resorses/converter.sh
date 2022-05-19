#! /bin/bash


if [[  -z $1  ]]; then
	echo "Скрипт работает в рабочем каталоге. В параметре передается желаемый размер в пикселях "
	return 0
else
	EXPORT_PATH="$(dirname "$PWD")"/png-$1;
	mkdir -p $EXPORT_PATH;
	echo $EXPORT_PATH
	for file in ${PWD}/*.svg 
	do
		echo 'Конвертация: '$filename
		filename=$(basename $file) 
		inkscape --export-filename=$EXPORT_PATH/${filename%.svg}.png -w $1 -h $1 $file
	done
fi

