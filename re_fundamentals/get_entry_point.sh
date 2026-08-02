#!/bin/bash

# 1. Arqumentin verilib-verilmədiyini yoxlayırıq
if [ $# -ne 1 ]; then
    echo "İstifadə qaydası: $0 <elf_fayl_adı>"
    exit 1
fi

file_name=$1

# 2. Faylın mövcudluğunu yoxlayırıq
if [ ! -f "$file_name" ]; then
    echo "Xəta: '$file_name' faylı tapılmadı!"
    exit 1
fi

# 3. Faylın həqiqətən ELF olub-olmadığını yoxlayırıq
if ! readelf -h "$file_name" &>/dev/null; then
    echo "Xəta: '$file_name' etibarlı bir ELF faylı deyil!"
    exit 1
fi

# 4. readelf vasitəsilə lazımi məlumatları çıxarırıq və xargs ilə təmizləyirik
magic_number=$(readelf -h "$file_name" | grep "Magic:" | sed 's/^[[:space:]]*Magic:[[:space:]]*//' | xargs)
class=$(readelf -h "$file_name" | grep "Class:" | sed 's/^[[:space:]]*Class:[[:space:]]*//' | xargs)

# Byte Order üçün yalnız vergüldən sonrakı hissəni götürürük və boşluqları silirik
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk -F', ' '{print $2}' | xargs)

entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | sed 's/^[[:space:]]*Entry point address:[[:space:]]*//' | xargs)

# 5. messages.sh faylını skriptə daxil edirik və funksiyanı çağırırıq
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
