require 'csv'
$races = {}
csv = CSV.open('vendor/data/ethnicity.csv', 'r')
csv.each do |row|
  $races[row[0]] = {"white"=>row[5], "black" => row[6], "asian_or_pacific_islander" => row[7], "american_indian_or_alaska_native" => row[8], "multiple" => row[9], "hispanic" => row[10], "rank" => row[1]}
end
