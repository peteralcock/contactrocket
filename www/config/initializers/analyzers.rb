require 'phonelib'
require 'stopwords'
require 'sentimental'
require 'odyssey'
require 'sad_panda'
Phonelib.default_country = "US"
$sentimental = Sentimental.new
$stopwords_filter = Stopwords::Snowball::Filter.new "en"
# ActiveMedian.create_function
# $total_company_count = Company.count