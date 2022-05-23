$social_network_colors = {}
$social_network_colors[:facebook] = "#3b5998"
$social_network_colors[:twitter] = "#55acee"
$social_network_colors[:okcupid] = "#3b5998"
$social_network_colors[:instagram] = "#e95950"
$social_network_colors[:pinterest] = "#cb2027"
$social_network_colors[:linkedin] = "#007bb5"
$social_network_colors[:google] = "#dd4b39"
$social_network_colors[:tumblr] = "#32506d"
$social_network_colors[:vk] = "#45668e"
$social_network_colors[:vimeo] = "#aad450"
$social_network_colors[:foursquare] = "#0072b1"
$social_network_colors[:dribbble] = "#000000"
$social_network_colors[:stumbleupon] = "#000000"
$social_network_colors[:wordpress] = "#000000"
$social_network_colors[:vine] = "#00bf8f"
$social_network_colors[:snapchat] = "#fffc00"
$social_network_colors[:youtube] = "#bb0000"
$social_network_colors[:flickr] = "#ff0084"
$social_network_colors[:github] = "#000000"
$social_network_colors[:yelp] = "#c41200"
$social_network_colors[:soundcloud] = "#ff7700"
$social_network_colors[:lastfm] = "#c3000d"
$social_network_colors[:sourceforge] = "#000000"
$social_network_colors[:meetup] = "#e51937"
$social_network_colors[:reddit] = "#FF5700"
$social_network_colors[:rss] = "#ff6600"
$social_network_colors[:spotify] = "#00e461"

$social_networks = []
$social_network_colors.keys.each do |key|
  $social_networks << key.to_s.delete(":")
end
