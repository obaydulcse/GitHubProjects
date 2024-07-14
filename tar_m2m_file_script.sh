#!/bin/bash
# This script will compress all csv files from /root/transactional_all_cdr/ to /root/tar_files_by_obaydul/transactional_all_cdr/

directory="/root/transactional_all_cdr/"
output_directory="/root/tar_files_by_obaydul/transactional_all_cdr/"

cd "$directory" || exit

for file in *.csv; do
    if [ -f "$file" ]; then
        tar -czvf "$output_directory/$file.tar.gz" "$file"
    fi
done



 #nohup bash tar_script.sh > tar_script.log &
 
 
 
 
 
 
#!/bin/bash
# Un Tar This script will compress all csv files from /root/transactional_all_cdr/ to /root/tar_files_by_obaydul/transactional_all_cdr/

directory="/root/cdr_files/transactional_all_cdr/"
output_directory="/root/cdr_files/transactional_all_cdr/"

cd "$directory" || exit

for file in *.csv; do
    if [ -f "$file" ]; then
        tar -xzvf "$output_directory/$file.tar.gz" "$file"
    fi
done



#locally untar

#!/bin/bash
# Un Tar This script will compress all csv files from /root/transactional_all_cdr/ to /root/tar_files_by_obaydul/transactional_all_cdr/

directory="/home/obaydul/cdr_files/tar_transactional_cdr/"
output_directory="/home/obaydul/cdr_files/transactional_cdr/"

cd "$directory" || exit

for file in *.tar.gz; do
    if [ -f "$file" ]; then
        tar -xzvf "$output_directory/$file" "$file"
    fi
done


#This scripts will used to tar the files from the input_file name

#!/bin/bash

directory="/home/infozillion_sftp_user"
output_directory="/home/infozillion_sftp_user/tar_files_by_obaydul"
input_file="/home/infozillion_sftp_user/tar_files_by_obaydul/files_name_for_tar.txt"

cd "$directory" || exit

while IFS= read -r file; do
    if [ -f "$file" ]; then
        tar -czvf "$output_directory/${file}.tar.gz" "$file"
    fi
done < "$input_file"



#untar files using loop
#!/bin/bash

tar_directory="/home/obaydul/2023-July"
extract_directory="/home/obaydul/2023-July/untar-files"

mkdir -p "$extract_directory"

cd "$tar_directory" || exit

for tar_file in *.tar.gz; do
    if [ -f "$tar_file" ]; then
        tar -xzvf "$tar_file" -C "$extract_directory"
    fi
done

