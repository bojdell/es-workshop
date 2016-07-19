# es-workshop
Companion code for the [Elasticsearch Intern Workshop](https://workday-search-intern-workshop.eventbrite.com). Clone this in your terminal by running `git clone git@github.com:bojdell/es-workshop.git`. This will copy all the code to your computer under the directory `es-workshop`.

## Overview
The workshop is split into 2 parts:

1. Elasticsearch API Basics (~30 mins)
    - We will be using the [Sense Kibana plugin](https://www.elastic.co/guide/en/sense/current/introduction.html) to explore Elasticsearch's APIs. We will [install it](https://www.elastic.co/guide/en/sense/current/installing.html) as part of the workshop and go over some of the commands in `sense_commands.txt`.
2. Building a Product with Elasticsearch (~80 mins)
    - We will be implementing bits of logic in a twitter search engine.
        - Setup (~20 mins)
        - Challenge 1 (~20 mins)
        - Challenge 2 (~20 mins)
        - Challenge 3 (~20 mins)

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
    - Also install the [Sense Plugin](https://www.elastic.co/guide/en/sense/current/installing.html) for Kibana
3. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (`brew install ruby` for Homebrew users)
4. Install [Node.js](https://nodejs.org/en/download/) (`brew install node`. More info here: http://blog.teamtreehouse.com/install-node-js-npm-mac)
5. Install [Express](https://expressjs.com/), a Node.js framework (`npm install express`)
6. Have a lightweight text editor available (we recommend Sublime Text: https://www.sublimetext.com/3, but use whatever you like)
7. Be semi-comfortable navigating your terminal of choice (ideally POSIX)

## Indexing the Dataset
The sample dataset for this workshop was obtained from Twitter by retrieving recent tweets from the ["100 Best Tech People On Twitter"](http://www.businessinsider.com/100-best-tech-people-on-twitter-2014-2014-11?op=1) (excluding retweets). These handles are listed in `data/handles.txt` with a few updates for handles that have changed over the years.

This data is contained in the archive `data/tweets.zip`. Expanding this archive inside `data/` yields a directory `data/tweets/` cointaining JSON files of tweet data for each handle in `data/handles.txt`. This data was fetched using the script `data/fetch_tweets.rb`, which can be re-run to update the data (you will need to obtain your own [Twitter API key](https://apps.twitter.com/) to do this).

### Indexing TL;DR:
To index the dataset into Elasticsearch, first make sure Elasticsearch is running (we assume it's using the default port of `9200`). Then, `cd data/` and run `./index_tweets.rb`. Once this has completed, the data will be available in ES inside the index `tweets`.

## Running the Site
Once you've installed Node.js, navigate to `es-workshop` and run `node server.js`. The server will start listening on port `3000`, and if you navigate to [http://localhost:3000](http://localhost:3000), you can begin interacting with the workshop site.
