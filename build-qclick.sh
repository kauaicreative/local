#!/bin/bash

# Build the Flutter web app
echo "Building Flutter web app..."
# flutter build web --release
flutter build web

# Check if the build was successful
if [ $? -ne 0 ]; then
    echo "Flutter build failed. Exiting."
    exit 1
fi

# Define the source and destination paths
SOURCE_DIR="$(pwd)/build/web"
REMOTE_DIR="/home/qclick/webapps/qclick"

echo "Copying files to remote server..."
# ssh qclick "mkdir -p $REMOTE_DIR"
# Use SSH to copy the files
scp -r $SOURCE_DIR/* qclick:$REMOTE_DIR

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "Deployment successful!"
else
    echo "Error occurred while copying files. Please check your SSH connection and try again."
    exit 1
fi