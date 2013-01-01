#!/bin/bash

# creates a new post by copying from a template

echo "Creating new post"

# get template
echo "Enter template [ text.md, link.md, photo.md, quote.md, video.md ]: "
read TEMPLATE
read -p "Enter slug, i.e. my-post-slug: " SLUG

# get file extension 
COPY_FILE=_templates/$TEMPLATE
COPY_FILE_NAME=$(basename $COPY_FILE)
COPY_FILE_EXT=${COPY_FILE_NAME##*.}

# create file
POST_FILE=_posts/$(date "+%Y-%m-%d")-$SLUG.$COPY_FILE_EXT

# echo new post:
echo $POST_FILE
cp $COPY_FILE $POST_FILE
# open it
vim $POST_FILE
