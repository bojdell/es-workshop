/**
*   Write your solution to the warmup in this file
*/
function generateEsQuery(queryString) {
  return {
    "query": {
      "query_string" : {
        "query" : queryString
      }
    },
    "_source": [
      "user.name",
      "user.screen_name",
      "created_at",
      "text",
      "entities*"
    ]
  }
}
