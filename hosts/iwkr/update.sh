#!/usr/bin/env bash

# forked from gitlab:marcaux/g14-2021-s3-dsdt

set -e

TMP_DIR=$(mktemp -d -t "modify-dsdt-$(date +%Y-%m-%d-%H-%M-%S)-XXXXXXXXXX")
CURRENT_DIR=$(pwd)

echo "$TMP_DIR"
cd "$TMP_DIR"

echo "Dumping data from DSDT tables - sudo is required"
sudo cat /sys/firmware/acpi/tables/DSDT > dsdt.dat
echo "Data succesfully dumped"

echo "Disassemble tables"
iasl -d dsdt.dat
echo "Disassemble completed"

echo "Making modification to tables"
sed -i 's/Name (SS3, Zero)/Name (SS3, One)/g' dsdt.dsl
# This line also required modifying in case of my laptop
sed -i 's/Name (XS3, Package (0x04)/Name (_S3, Package (0x04)/g' dsdt.dsl
echo "Tables are modified"

echo "Increment version"
VERSION_REGEX='(.*DefinitionBlock \(.*,.*,.*,.*,.*, *0x)(.*)(\).*)'
CURRENT_VERSION=$(pcregrep -o2 "${VERSION_REGEX}" dsdt.dsl)
INCREMENTED_VERSION=$(echo "obase=ibase=16;$CURRENT_VERSION+1" | bc)
sed -i -E "s/${VERSION_REGEX}/\1${INCREMENTED_VERSION}\3/g" dsdt.dsl
echo "Version incremented"

echo "Creating AML table"
iasl -tc dsdt.dsl
echo "Created AML table"

echo "Packaging to CPIO archive"
mkdir -p "kernel/firmware/acpi"
cp dsdt.aml "kernel/firmware/acpi"
find kernel | cpio -H newc --create > "${TMP_DIR}/acpi_override"
echo "Successfully packaged"

echo "copying CPIO archive to this dir"
cp "${TMP_DIR}/acpi_override" "${CURRENT_DIR}/acpi_override"

rm -rf "${TMP_DIR}"
