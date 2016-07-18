function generateEsQuery(queryString, selectedUser) {
  return {
    "query": {
      "query_string" : {
        "query" : queryString
      }
    }
  }
}
