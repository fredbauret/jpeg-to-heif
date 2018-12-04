#!/usr/bin/env bash

subdir=${1:-images}

echo "converting in subdir: ./$subdir"

cd /gpac/$subdir
for F in $(ls *.[jJ][pP][gG] *.[jJ][pP][eE][gG] 2>/dev/null); do
  if ! [ -f $F.heic ]; then
    ffmpeg -i ./$F -crf 23 -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -preset slower -pix_fmt yuv420p -f hevc $F.hvc && \
    MP4Box -add-image $F.hvc -ab heic -new $F.heic && \
     rm $F.hvc
  fi
done
