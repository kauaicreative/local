#!/bin/bash

# Build the Flutter web app
# flutter build web
flutter build web

# Create the docs directory if it doesn't exist
mkdir -p docs

# Copy the contents of the build/web directory to the docs directory
cp -r build/web/* docs/

# Get the current time in your preferred format
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")

# Path to the index.html file you want to modify
HTML_FILE="docs/index.html"

# New base href value
NEW_BASE_HREF="/local/"

perl -pi -e "s|<base href=\"\/\">|<base href=\"${NEW_BASE_HREF}\">|g; s|<title>flutter_app_1</title>|<title>Local (${CURRENT_TIME})</title>|g" "${HTML_FILE}"

# Commit and push changes to Git
echo "Committing and pushing changes..."
git add .
git commit -m "Update (${CURRENT_TIME})"
git push 

echo "index.html updated successfully!"
