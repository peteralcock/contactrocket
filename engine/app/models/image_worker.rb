
class ImageWorker

  def self.post(url, path, body={})
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(path)
    request.add_field('Content-Type', 'application/json')
    request.body =  body.to_json
    response = http.request(request)
    response.body
  end


  def self.new_image_service
    system("curl -X PUT 'http://#{ENV['API_HOST']}:8080/services/imageserv' -d '{\"mllib\":\"caffe\",\"description\":\"image classification service\",\"type\":\"supervised\",\"parameters\":{\"input\":{\"connector\":\"image\"},\"mllib\":{\"nclasses\":1000}},\"model\":{\"repository\":\"/opt/models/ggnet/\"}}'")
  end


  def self.predict_image(url)
    body = {"service"=>"imageserv", "parameters"=>{"input"=>{"width"=>224, "height"=>224}, "output"=>{"best"=>3}}, "data"=>["#{url}"]}
    uri = URI.parse("http://#{ENV['API_HOST']}:8080")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new("/predict")
    request.add_field('Content-Type', 'application/json')
    request.body =  body.to_json
    response = http.request(request)
    response.body
  end



  def self.train_image(url, tags=[])
    body = {"service"=>"imageserv", "async"=>true, "parameters"=>{"mllib"=>{"gpu"=>false, "net"=>{"batch_size"=>32}, "solver"=>{"test_interval"=>500, "iterations"=>30000, "base_lr"=>0.001, "stepsize"=>1000, "gamma"=>0.9}}, "input"=>{"connector"=>"image", "test_split"=>0.1, "shuffle"=>true, "width"=>224, "height"=>224}, "output"=>{"measure"=>["acc", "mcll", "f1"]}}, "data"=>tags}
    uri = URI.parse("http://#{ENV['API_HOST']}:8080")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new("/train")
    request.add_field('Content-Type', 'application/json')
    request.body =  body.to_json
    response = http.request(request)
    response.body
  end



  def self.ocr_image(url)
    uri = URI.parse("http://#{ENV['API_HOST']}:9292")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new("/ocr")
    request.add_field('Content-Type', 'application/json')
    request.body =  {:img_url => url, :worker => "tesseract"}.to_json
    response = http.request(request)
    response.body
  end




  def self.create_services
    json = '{
   "service":"imageserv",
       "parameters":{
         "mllib":{
           "gpu":true
         },
         "input":{
           "width":224,
           "height":224
         },
         "output":{
           "best":3,
           "template":"{ {{#body}}{{#predictions}} \"uri\":\"{{uri}}\",\"categories\": [ {{#classes}} { \"category\":\"{{cat}}\",\"score\":{{prob}} } {{^last}},{{/last}}{{/classes}} ] {{/predictions}}{{/body}} }",
           "network":{
             "url":"your-elasticsearch-server.com/images/img",
             "http_method":"POST"
           }
         }
       },
       "data":["http://i.ytimg.com/vi/0vxOhd4qlnA/maxresdefault.jpg"]
     }'
    result =   system("curl -XPOST 'http://localhost:8080/predict' -d #{json}")
  end




end
