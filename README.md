# es-workshop
Companion code for the [Elasticsearch Intern Workshop](https://workday-search-intern-workshop.eventbrite.com). Clone this in your terminal by running `git clone git@github.com:bojdell/es-workshop.git`. This will copy all the code to your computer under the directory `es-workshop`.

## Before You Begin
Please make sure you have set up the following things:

1. Download Elasticsearch 2.3.x and follow installation instructions: https://www.elastic.co/downloads/elasticsearch
    - _IMPORTANT: Be sure to add the following lines to Elasticsearch's config file `elasticsearch.yml` before starting ES:_
    ```yaml
        http.cors.enabled: true
        http.cors.allow-methods: OPTIONS, HEAD, GET
        http.cors.allow-origin: /https?:\/\/localhost(:[0-9]+)?/
    ```
2. Download Kibana 4.5.x and follow installation instructions: https://www.elastic.co/downloads/kibana
3. Install [Node.js](https://nodejs.org/en/download/) (Homebrew users can run `brew install node`. More info here: http://blog.teamtreehouse.com/install-node-js-npm-mac)
4. Have a lightweight text editor available (we recommend Sublime Text: https://www.sublimetext.com/3, but use whatever you like)
5. Be semi-comfortable navigating your terminal of choice (ideally POSIX)

## Indexing the Dataset
The sample dataset for this workshop was obtained from Twitter by retreiving recent tweets from the ["100 Best Tech People On Twitter"](http://www.businessinsider.com/100-best-tech-people-on-twitter-2014-2014-11?op=1) (excluding retweets). These handles are listed in `handles.txt` with a few updates for handles that have changed over the years.

This data is contained in the archive `tweets.zip`. Expanding this archive yields a directory `tweets/` caintaining JSON files of tweet data for each handle in `handles.txt`. This data was fetched using the script `fetch_tweets.rb`, which can be re-run to update the data (you will need to obtain your own [Twitter API key](https://apps.twitter.com/) to do this).

### Indexing TL;DR:
To index the dataset into Elasticsearch, first make sure Elasticsearch is running (we assume it's using the default port of `9200`). Then, run `./index_tweets.rb`. Once this has completed, the data will be available in ES inside the index `tweets`.

## Running the Site
Once you've installed Node.js, navigate to `es-workshop` and run `node server.js`. The server will start listening on port `3000`, and if you navigate to http://localhost:3000, you can begin interacting with the workshop site.
