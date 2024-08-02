for file in *.jpg; do
   convert $file -resize 640 thumbs/$file
done
