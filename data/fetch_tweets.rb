#!/usr/bin/ruby

##
# This script fetches tweet data for all twitter handles listed in handles.txt
# See comments in the code for more info on the Twitter APIs used.
#
# Note: requires `jq` to run: http://brewformulas.org/jq
##

require 'json'

handles = File.read('handles.txt').split("\n").map(&:strip).map(&:downcase)
# handles = ['<handle>'] # use this to re-fetch a single handle

# see https://dev.twitter.com/oauth/application-only for more info on how this works
def get_token()
  bearer_token_creds_base64 = '' # add your base64-encoded credentials here

  res_json = ` curl -Ss --fail -XPOST \
      -H "Authorization: Basic #{bearer_token_creds_base64}" \
      -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" \
      -d 'grant_type=client_credentials' \
      'https://api.twitter.com/oauth2/token'
  `
  res = JSON.parse(res_json)
  res['access_token']
end

handles.each_with_index do |handle, i|
  # see https://dev.twitter.com/rest/reference/get/statuses/user_timeline for more info
  `curl -Ss --fail --get 'https://api.twitter.com/1.1/statuses/user_timeline.json' -d 'screen_name=#{handle}&include_rts=false&count=200' -H 'Authorization: Bearer #{get_token}' | jq . > tweets/#{handle}.json`
  puts "#{'%3.3s' % i}: Fetched data for #{handle}"
  sleep 0.1
end
