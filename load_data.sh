rm -rf load_data.log
touch load_data.log
for file_name in `ls tools/*.dat`; do
    table_file=$(echo "${file_name##*/}")
    table_name=$(echo "${table_file%.*}" | tr '[:lower:]' '[:upper:]')
    load_data_sql="LOAD DATA LOCAL INFILE '$file_name' INTO TABLE $table_name FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';"
    nohup mysql -u root -p123 --local-infile=1 -D tpcds -e "$load_data_sql" >> load_data.log 2>&1 &
done