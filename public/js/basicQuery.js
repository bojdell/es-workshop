function generateEsQuery(queryString) {
  return {
    "query": {
      "query_string" : {
        "query" : queryString
      }
    },
    "fields": [
      "user.name",
      "user.screen_name",
      "created_at",
      "text"
    ]
  }
}
