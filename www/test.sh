#!/bin/bash -ex
set -e

# Image Classification
# curl -X POST "http://api.your-server.net:8883/predict" -d "{\"service\":\"imageserv\",\"parameters\":{\"input\":{\"width\":224,\"height\":224},\"output\":{\"best\":3},\"mllib\":{\"gpu\":false}},\"data\":[\"http://i.ytimg.com/vi/0vxOhd4qlnA/maxresdefault.jpg\"]}"

# Text Analysis
curl http://api.your-server.net:5000/api --header 'content-type: application/json' --data '{"text": "This is a text that I want to be analyzed. My name is Peter Alcock and I live in Boston, MA."}' -X POST
# curl http://api.your-server.net:8880/add --header 'content-type: application/x-www-form-urlencoded' --data '{"filepath":"britney.jpg" , "url": "http://i.ytimg.com/vi/0vxOhd4qlnA/maxresdefault.jpg"}' -X POST
curl -d "text=I%20am%20happy" http://api.your-server.net:8880
curl -X POST -H "Content-Type: application/json" -d '{"img_url":"http://bit.ly/ocrimage","engine":"tesseract"}' http://api.your-server.net:9292/ocr
curl http://api.your-server.net:8882/locate?ip=172.56.38.214
exit 0
