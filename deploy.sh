#!/bin/bash

cd

unzip -o blog-backend-1.0-SNAPSHOT.zip

rm blog-backend-1.0-SNAPSHOT.zip

kill $(lsof -t -i:9000)

printenv

nohup blog-backend-1.0-SNAPSHOT/bin/blog-backend -Dplay.http.secret.key=${APPLICATION_SECRET} &

