#!/bin/bash

echo "Finding last downloaded episode"

# Downloaded Security Now! files
SNDIR="$HOME/Music/iTunes/iTunes Music/Music/Steve Gibson/Security Now!"
# Directory for files to be automatically added to iTunes
ITUNES="$HOME/Music/iTunes/iTunes Music/Automatically Add to iTunes"
# Latest episode not downloaded
SHOWNUM=$(( `ls "$SNDIR" | sort -n | tail -n 1 | egrep -o '^[0-9]+'` + 1 ))
SHOWFILE=`printf sn%04d.mp3 $SHOWNUM`

echo "Downloading next episode: $SHOWNUM"

if curl -f `printf http://twit.cachefly.net/audio/sn/sn%04d/sn%04d.mp3 $SHOWNUM $SHOWNUM` -o "$HOME/$SHOWFILE"
then 
    cd $HOME
    
    TITLE=`id3v2 --list $SHOWFILE | grep "TIT2" | grep -o "): .*" | sed 's|): ||'`
    ARTIST="Steve Gibson"
    ALBUM="Security Now!"
    
    echo "Deleting old tags"
    id3v2 -D $SHOWFILE
    echo "Setting new tags"
    id3v2 -a "$ARTIST" -A "$ALBUM" -t "Security Now! $SHOWNUM: $TITLE" -T $SHOWNUM $SHOWFILE
    
    echo "Preparing to import to iTunes"
    mv $SHOWFILE "$ITUNES"
    
    echo "Open iTunes to complete import"
else
    echo "Episode does not exist yet"
fi
