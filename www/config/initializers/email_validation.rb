# if Rails.env.production?
#   c = Curl::Easy.perform('http://169.254.169.254/latest/meta-data/public-hostname')
#   $public_hostname = c.body_str
# else
  $public_hostname = 'localhost'
# end
