
require "faraday_middleware/aws_signers_v4"
Searchkick.client =
    Elasticsearch::Client.new(
        url: ENV["ELASTICSEARCH_URL"],
        transport_options: {request: {timeout: 10}}
    )
