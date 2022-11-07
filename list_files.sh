search_dir=./build
for entry in "$search_dir"/*
do
  filename=$(basename $entry)
  echo "$filename"
done

