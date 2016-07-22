# Useful Links
Sign-in / Chat: https://docs.google.com/spreadsheets/d/1Inwqw5xeJM2OqSaclg90wxoq-8PZv6yxOm7PnmJA6vc/edit?usp=sharing

Twitter Handle Suggestions: https://docs.google.com/spreadsheets/d/12qazCJs2qmo2anRqnDGg9JmGsek5Xs3U725HxaFzHJo

If you installed ES w/ homebrew, YML file is here: `libexec/config/elasticsearch.yml`

# es-workshop
Companion code for the [Elasticsearch Intern Workshop](https://workday-search-intern-workshop.eventbrite.com). Clone this in your terminal by running `git clone https://github.com/bojdell/es-workshop.git`. This will copy all the code to your computer under the directory `es-workshop`.

## Overview
The workshop is split into the following components:

1. Installation / Setup (~25 mins)
2. Elasticsearch API Basics (~25 mins)
3. Building a Product with Elasticsearch (~60 mins)
    - Warmup (~5 mins)
    - Challenge 1 (~20 mins)
    - Challenge 2 (~20 mins)
    - Challenge 3 (~20 mins)

## 1) Installation / Setup (~25 mins)
Please set up the following things before proceeding:

1. Download Elasticsearch 2.3.x and follow installation instructions: https://www.elastic.co/downloads/elasticsearch
    - _IMPORTANT: Be sure to add the following lines to Elasticsearch's config file `elasticsearch.yml` and restart ES:_
    ```yaml
        http.cors.enabled: true
        http.cors.allow-methods: OPTIONS, HEAD, GET
        http.cors.allow-origin: /https?:\/\/localhost(:[0-9]+)?/
    ```
2. Download Kibana 4.5.x and follow installation instructions: https://www.elastic.co/downloads/kibana
    - Also install the [Kibana Sense Plugin](https://www.elastic.co/guide/en/sense/current/installing.html) `./bin/kibana plugin --install elastic/sense` and restart Kibana
    - If this is working properly, you can access Sense here: [http://localhost:5601/app/sense](http://localhost:5601/app/sense)
3. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (`brew install ruby` for Homebrew users)
4. Install [Node.js](https://nodejs.org/en/download/) (`brew install node`)
5. Install [Express](https://expressjs.com/), a Node.js framework (`npm install -g express`)
6. Have a lightweight text editor available (we recommend Sublime Text: https://www.sublimetext.com/3, but use whatever you like)
7. Be semi-comfortable navigating your terminal of choice (ideally POSIX)

## 2) Elasticsearch API Basics (~25 mins)
Open the file `sense_commands.txt`. Navigate to Sense at [http://localhost:5601/app/sense](http://localhost:5601/app/sense). Paste the contents of `sense_commands.txt` into Sense.

Note the keyboard shortcuts in the help menu, in particular: `Ctrl/Cmd + Enter = Submit request`.

Read through the comments and execute the commands one at a time.

## 3) Building a Product with Elasticsearch (~60 mins)
Useful tools during this section are Sense (for debugging queries / inspecting ES data), and the Chrome Dev Console (to debug Javascript errors). You can open Dev Console via `Cmd/Ctrl + J`.

### Indexing the Dataset
The base dataset for this workshop was obtained from Twitter by retrieving recent tweets from the ["100 Best Tech People On Twitter"](http://www.businessinsider.com/100-best-tech-people-on-twitter-2014-2014-11?op=1) (excluding retweets). These handles are listed in `data/handles.txt` with a few updates for handles that have changed over the years.

The tweet data is contained in the archive `data/tweets.zip`. Expanding this archive inside `data/` yields a directory `tweets/` cointaining JSON files of tweet data for each handle in `data/handles.txt`. This data was fetched using the script `data/fetch_tweets.rb`, which can be re-run to update the data (you will need to obtain your own [Twitter API key](https://apps.twitter.com/) to do this).

#### Indexing TL;DR:
To index the dataset into Elasticsearch, first make sure Elasticsearch is running (we assume it's using the default port of `9200`). Then:

- `cd data/`
- `unzip tweets.zip`
- `./index_tweets.rb`

Once this has completed, the data will be available in ES inside the index `tweets`.

### Run the Web Server
To run our demo search engine, `cd` into `es-workshop` and run `node server.js`. The server will start listening on port `3000`, and if you navigate to [http://localhost:3000](http://localhost:3000), you can begin interacting with the app.

### Warmup
Edit the file `public/js/basicQuery.js` to also retrieve the field for a user's profile pic (hint: copy the query into Sense and play around with it. You will need to provide a value for `queryString`. Try removing the field filters to see what data is available on each tweet.)

The app will pick up your changes after you save the file and refresh the page you are on. `basicQuery.js` is used on the `Home` page.

### Challenges 1-3
Follow the instrutions on each page to solve the challenge. Again remember that you can use Sense / Chrome Dev Console to debug things. One participant will share his/her solution to each challenge.
