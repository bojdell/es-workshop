# es-workshop
Elasticsearch workshop code

## The Dataset
The sample dataset for this workshop was obtained from Twitter by retreiving recent tweets from the ["100 Best Tech People On Twitter"](http://www.businessinsider.com/100-best-tech-people-on-twitter-2014-2014-11?op=1) (excluding retweets). These handles are listed in `handles.txt` with a few updates for handles that have changed over the years.

This data is contained in the archive `tweets.zip`. Expanding this archive yields a directory `tweets/` caintaining JSON files of tweet data for each handle in `handles.txt`. This data was fetched using the script `fetch_tweets.rb`, which can be re-run to update the data (you will need to obtain your own [Twitter API key](https://apps.twitter.com/) to do this).

### Indexing the Dataset
To index the dataset into Elasticsearch, first make sure Elasticsearch is running (we assume it's using the default port of `9200`). Then, run `./index_tweets.rb`. Once this has completed, the data will be available in ES inside the index `tweets`.