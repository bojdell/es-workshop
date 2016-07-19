#!/usr/bin/ruby

##
# This script indexes JSON data retrieved via ./fetch_tweets.rb into Elasticsearch.
# See https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html
# for more info on bulk indexing.
##

require 'json'

INDEX_NAME = 'tweets'
DATA_TYPE = 'tweet'
BULK_DATA_TMP_FILE = '/tmp/bulk_data'

tweet_data = Dir['tweets/*']
# tweet_data = ['tweets/<handle>.json'] # use this to re-index a single handle

def bulk_index_request(id)
  { :index => { :_index => INDEX_NAME, :_type => DATA_TYPE, :_id => id } }
end

def index_tweets(tweets)
  output = tweets.flat_map do |tweet|
    [
      bulk_index_request(tweet['id_str']),
      tweet
    ].map { |json| JSON.generate(json) }
  end.join("\n")

  File.write(BULK_DATA_TMP_FILE, output)

  `curl -Ss --fail -XPOST "http://localhost:9200/_bulk" --data-binary "@#{BULK_DATA_TMP_FILE}"`

  File.delete(BULK_DATA_TMP_FILE)
end

tweet_data.each_with_index do |file, i|
  tweets = JSON.parse(File.read(file))
  index_tweets(tweets)
  puts "#{'%3.3s' % i}: Indexed data from #{file}"
  sleep 0.1
end
