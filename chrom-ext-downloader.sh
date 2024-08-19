#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 -e EXTENSION_ID -v VERSION -d DOWNLOAD_DIR"
    echo "  -e EXTENSION_ID   The ID of the Chrome extension."
    echo "  -v VERSION        The version of the Chromium browser."
    echo "  -d DOWNLOAD_DIR    The directory where the CRX file will be saved."
    exit 1
}

# Parse command line arguments
while getopts ":e:v:d:" opt; do
    case ${opt} in
        e )
            EXTENSION_ID=$OPTARG
            ;;
        v )
            VERSION=$OPTARG
            ;;
        d )
            DOWNLOAD_DIR=$OPTARG
            ;;
        \? )
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Validate arguments
if [ -z "${EXTENSION_ID}" ] || [ -z "${VERSION}" ] || [ -z "${DOWNLOAD_DIR}" ]; then
    usage
fi

# Create download directory if it does not exist
mkdir -p "${DOWNLOAD_DIR}"

# Define CRX URL
CRX_URL="https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${VERSION}&x=id%3D${EXTENSION_ID}%26installsource%3Dondemand%26uc"

# Define output file
OUTPUT_FILE="${DOWNLOAD_DIR}/${EXTENSION_ID}.crx"

# Download the CRX file using curl
echo "Downloading CRX file from ${CRX_URL}..."
curl -L -o "${OUTPUT_FILE}" "${CRX_URL}"

# Verify if the download was successful
if [ $? -eq 0 ]; then
    echo "Download successful! File saved to ${OUTPUT_FILE}"
else
    echo "Download failed!"
    exit 1
fi
