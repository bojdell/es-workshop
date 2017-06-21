#! /usr/bin/env ruby

##
# This script indexes JSON data retrieved via ./fetch_tweets.rb into Elasticsearch.
# See https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html
# for more info on bulk indexing.
##

require 'json'
require 'net/http'
require 'uri'

INDEX_NAME = 'tweets'
DATA_TYPE = 'tweet'

tweet_data = Dir['tweets/*']
# tweet_data = ['tweets/<handle>.json'] # use this to re-index a single handle

def bulk_index_request(id)
  { :index => { :_index => INDEX_NAME, :_type => DATA_TYPE, :_id => id } }
end

def index_tweets(tweets)
  uri = URI.parse('http://localhost:9200/_bulk')
  request = Net::HTTP::Post.new(uri)
  request['Content-Type'] = 'application/json'
  request.body = tweets.flat_map do |tweet|
    [bulk_index_request(tweet['id_str']), tweet].map {|x| JSON.generate x}
  end.join("\n")

  Net::HTTP.start(uri.host, uri.port) do |http|
    response = http.request(request)
    return Net::HTTPSuccess === response
  end
end

tweet_data.each_with_index do |file, i|
  begin
    tweets = JSON.parse(File.read(file))
    s = index_tweets(tweets)
    puts '%3i) %s: %s' % [i, (s ? 'SUCCESS' : 'FAILURE'), file]
    sleep 0.1
  rescue => e
    puts "Error indexing tweets for #{file}: #{e}"
  end
end
