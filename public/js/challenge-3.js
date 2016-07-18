function generateEsQuery() {
  return {
    "query": {
      "query_string" : {
        "query" : "*"
      }
    }
  }
}
