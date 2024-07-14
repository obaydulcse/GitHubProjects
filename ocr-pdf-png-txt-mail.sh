#!/bin/bash
#ocr.sh
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install tesseract-ocr libtesseract-dev tesseract-ocr-eng poppler-utils -y

DIR="$( cd "$( dirname "$0" )" && pwd )"

pdftoppm -png $DIR/$1.pdf $DIR/$1

for i in "$1"-*.png; do tesseract "$i" "text-$i" -l eng; done;

cat $DIR/text-$1* > $DIR/$1.txt
cat $DIR/$1.txt | egrep -o "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}" > $DIR/$1_mail.txt



