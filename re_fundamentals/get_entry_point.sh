#!/bin/bash

if [ $# -ne 1 ]; then
    echo "İstifadə qaydası: $0 <elf_fayl_adı>"
    exit 1
fi

file_name=$1

if [ ! -f "$file_name" ]; then
    echo "Xəta: '$file_name' faylı tapılmadı!"
    exit 1
fi

if ! readelf -h "$file_name" &>/dev/null; then
    echo "Xəta: '$file_name' etibarlı bir ELF faylı deyil!"
    exit 1
fi

magic_number=$(readelf -h "$file_name" | grep "Magic:" | sed 's/^[[:space:]]*Magic:[[:space:]]*//')
class=$(readelf -h "$file_name" | grep "Class:" | sed 's/^[[:space:]]*Class:[[:space:]]*//')
byte_order=$(readelf -h "$file_name" | grep "Data:" | sed 's/^[[:space:]]*Data:[[:space:]]*//')
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | sed 's/^[[:space:]]*Entry point address:[[:space:]]*//')

if [ -f "./messages.sh" ]; then
    source ./messages.sh
    display_elf_header_info
else
    echo "ELF Header Information for '$file_name':"
    echo "----------------------------------------"
    echo "Magic Number: $magic_number"
    echo "Class: $class"
    echo "Byte Order: $byte_order"
    echo "Entry Point Address: $entry_point_address"
fi
