#!/bin/bash -ex
rm -rf /tmp/dump*
export RAILS_APP_DIR=$(pwd)
ssh-add ~/.ssh/rockbox.pem 
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start 
cd /tmp && redis-server &
redis-cli flushall
tika &
cd  $RAILS_APP_DIR
docker-machine create -d virtualbox contactrocket
docker-machine start contactrocket
eval $(docker-machine env contactrocket)
docker-compose down
docker-compose up -d
sleep 10
echo "-- RUNNING TESTS --"

# Image Classification
curl -X PUT "http://localhost:8883/services/imageserv" -d "{\"mllib\":\"caffe\",\"description\":\"image classification service\",\"type\":\"supervised\",\"parameters\":{\"input\":{\"connector\":\"image\"},\"mllib\":{\"nclasses\":1000}},\"model\":{\"repository\":\"/opt/models/ggnet/\"}}"
curl -X POST "http://localhost:8883/predict" -d "{\"service\":\"imageserv\",\"parameters\":{\"input\":{\"width\":224,\"height\":224},\"output\":{\"best\":3},\"mllib\":{\"gpu\":false}},\"data\":[\"http://i.ytimg.com/vi/0vxOhd4qlnA/maxresdefault.jpg\"]}"

# Imaging Processing
curl http://localhost:9001

# Text Analysis
curl http://localhost:5000/api --header 'content-type: application/json' --data '{"text": "This is a text that I want to be analyzed. My name is Peter Alcock and I live in Boston, MA."}' -X POST
curl http://localhost:8888/add --header 'content-type: application/x-www-form-urlencoded' --data '{"filepath":"britney.jpg" , "url": "http://i.ytimg.com/vi/0vxOhd4qlnA/maxresdefault.jpg"}' -X POST
curl -d "text=I%20am%20happy" http://localhost:8880
curl -X POST -H "Content-Type: application/json" -d '{"img_url":"http://bit.ly/ocrimage","engine":"tesseract"}' http://localhost:9292/ocr
curl http://localhost:8882/locate?ip=172.56.38.214

cd ./web
bundle install
bundle exec rake db:setup
guard start

cd ../engine
bundle install
guard start &

cd ../crm
bundle install
bundle exec rails s -p 3001 -b 0.0.0.0 &

cd ../web
bundle install
bundle exec rake db:setup
guard start

exit 0
