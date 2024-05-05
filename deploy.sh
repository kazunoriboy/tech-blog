#!/bin/bash

cd ~/
ZIP="blog-backend-1.0-SNAPSHOT.zip"
NOW=`date +'%m%d%Y%H%M%S'`
DIR=${ZIP%.zip}
TARGET="${NOW}_${DIR}"
unzip -o $ZIP
mv $DIR "${NOW}_${DIR}"

kill $(lsof -t -i:9000)
find . -type d -name "*SNAPSHOT" | grep -v $NOW | xargs rm -r

$TARGET/bin/blog-backend -Dplay.http.secret.key=${APPLICATION_SECRET}

