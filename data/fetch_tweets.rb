#! /usr/bin/env ruby

##
# This script fetches tweet data for all twitter handles listed in handles.txt
# You will need a Twitter API key to run this, which should then be base64 encoded
# (as specified here: https://dev.twitter.com/oauth/application-only) and placed in your keychain
# with 'es-workshop-twitter-creds-base64' in the 'Where' field.
#
# This script also uses `jq`: http://brewformulas.org/jq
##

require 'json'

handles = File.read('handles.txt').split("\n").map(&:strip).map(&:downcase)
# handles = ['<handle>'] # use this to re-fetch a single handle

@bearer_token_creds_base64 = `security find-generic-password -s 'es-workshop-twitter-creds-base64' -w 2>/dev/null`.chomp

# see https://dev.twitter.com/oauth/application-only for more info on how this works
def get_token()
  res_json = ` curl -Ss --fail -XPOST \
      -H "Authorization: Basic #{@bearer_token_creds_base64}" \
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
