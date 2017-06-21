#### 6/21/17
 - Submit Twitter Handles here: [https://docs.google.com/spreadsheets/d/12qazCJs2qmo2anRqnDGg9JmGsek5Xs3U725HxaFzHJo/edit?usp=sharing](https://docs.google.com/spreadsheets/d/12qazCJs2qmo2anRqnDGg9JmGsek5Xs3U725HxaFzHJo/edit?usp=sharing)

# es-workshop
Clone this in your terminal by running `git clone https://github.com/bojdell/es-workshop.git`. This will copy all the code to your computer under the directory `es-workshop`. If you don't have [Git](https://git-scm.com/downloads), you will need to install it.

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

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (`brew install ruby` for [Homebrew](http://brew.sh/) users)
2. Run `gem install bundler`
3. Navigate to the `es-workshop` directory and run `bundle install`
4. Run `ruby install.rb` to install Elasticsearch and Kibana (this will create the `lib` dirctory)
5. In a new terminal tab, start Elasticsearch: `./lib/elasticsearch-*/bin/elasticsearch` (use `elasticsearch.bat` if you're on Windows)
6. In a new terminal tab, start Kibana: `./lib/kibana-*/bin/kibana` (use `kibana.bat` if you're on Windows)
7. Check that everything is working by navigating to the Kibana Dev Tools Console at [http://localhost:5601/app/kibana#/dev_tools/console](http://localhost:5601/app/kibana#/dev_tools/console)

#### Other Tips
- Have a lightweight text editor available (we recommend Sublime Text: https://www.sublimetext.com/3, but use whatever you like)
- Be semi-comfortable navigating your terminal of choice (ideally POSIX)

## 2) Elasticsearch API Basics (~25 mins)
Open the file `es_commands.txt`. Navigate to the Kibana Dev Tools Console at [http://localhost:5601/app/kibana#/dev_tools/console](http://localhost:5601/app/kibana#/dev_tools/console). Paste the contents of `es_commands.txt` into the console.

Note the keyboard shortcuts in the help menu, in particular: `Ctrl/Cmd + Enter = Submit request`.

Read through the comments and execute the commands one at a time.

## 3) Building a Product with Elasticsearch (~60 mins)

For this part, you will be working to create a search engine on real Twitter data. You will be solving challenges by implementing Elasticsearch queries. The search engine looks like this:

![screenshot](/public/img/screenshot.png?raw=true)

Note: during this section, the Kibana Dev Tools Console is useful for debugging queries / inspecting ES data and your browser's Web Dev Console will help with debugging any Javascript errors. You will want to keep the [Elasticsearch Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html) close by.

### Indexing the Dataset
The base dataset for this workshop was obtained from Twitter by retrieving recent tweets from the ["100 Best Tech People On Twitter"](http://www.businessinsider.com/100-best-tech-people-on-twitter-2014-2014-11?op=1) (excluding retweets). These handles are listed in `data/handles.txt` with a few updates for handles that have changed over the years.

The tweet data is contained in the archive `data/tweets.zip`. Expanding this archive inside `data/` yields a directory `tweets/` cointaining JSON files of tweet data for each handle in `data/handles.txt`. This data was fetched using the script `data/fetch_tweets.rb`, which can be re-run to update the data (you will need to obtain your own [Twitter API key](https://apps.twitter.com/) to do this).

#### Indexing TL;DR:
To index the dataset into Elasticsearch, first make sure Elasticsearch is running (we assume it's using the default port of `9200`). Then:

- `cd data/`
- `unzip tweets.zip`
- `ruby index_tweets.rb`

Once this has completed, the data will be available in ES inside the index `tweets`.

### Run the Web Server
To run our demo search engine, `cd` into `es-workshop` and run `ruby server.rb`. The server will start listening on port `3000`, and if you navigate to [http://localhost:3000](http://localhost:3000), you can begin interacting with the app.

### Warmup
Edit the file `public/js/basicQuery.js` to also retrieve the field for a user's profile pic (hint: copy the query into the Kibana Dev Tools Console and play around with it. You will need to provide a value for `queryString`. Try removing the field filters to see what data is available on each tweet.)

The app will pick up your changes after you save the file and refresh the page you are on. `basicQuery.js` is used on the `Home` page.

### Challenges 1-3
Follow the instrutions on each page to solve the challenge. Again remember that you can use the Kibana Dev Tools Console / Chrome Dev Console to debug things. One participant will share his/her solution to each challenge.

### Feedback
You can provide feedback on the workshop here: [http://goo.gl/forms/dI2uK0HGPmbCAXh12](http://goo.gl/forms/dI2uK0HGPmbCAXh12). Please help us make it better for future sessions!
