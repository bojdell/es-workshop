# es-workshop
Companion code for the [Elasticsearch Intern Workshop](https://workday-search-intern-workshop.eventbrite.com).

## Before You Begin
Please make sure you have set up the following things:
1. Download Elasticsearch 2.3.x and follow installation instructions: https://www.elastic.co/downloads/elasticsearch
    - *IMPORTANT: Be sure to add the following lines to Elasticsearch's config file `elasticsearch.yml` before starting ES:*
```
    http.cors.enabled: true
    http.cors.allow-methods: OPTIONS, HEAD, GET
    http.cors.allow-origin: /https?:\/\/localhost(:[0-9]+)?/
```
2. Download Kibana 4.5.x and follow installation instructions: https://www.elastic.co/downloads/kibana
3. Have a lightweight text editor available (we recommend Sublime Text: https://www.sublimetext.com/3, but use whatever you like)
4. Be semi-comfortable navigating your terminal of choice (ideally POSIX)

## Indexing the Dataset
The sample dataset for this workshop was obtained from Twitter by retreiving recent tweets from the ["100 Best Tech People On Twitter"](http://www.businessinsider.com/100-best-tech-people-on-twitter-2014-2014-11?op=1) (excluding retweets). These handles are listed in `handles.txt` with a few updates for handles that have changed over the years.

This data is contained in the archive `tweets.zip`. Expanding this archive yields a directory `tweets/` caintaining JSON files of tweet data for each handle in `handles.txt`. This data was fetched using the script `fetch_tweets.rb`, which can be re-run to update the data (you will need to obtain your own [Twitter API key](https://apps.twitter.com/) to do this).

### Indexing TL;DR:
To index the dataset into Elasticsearch, first make sure Elasticsearch is running (we assume it's using the default port of `9200`). Then, run `./index_tweets.rb`. Once this has completed, the data will be available in ES inside the index `tweets`.