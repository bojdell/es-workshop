/**
*   Write your solution to Challenge 1 in this file
*/
function generateEsQuery(queryString) {
  return {
    "query": {
      "query_string" : {
        "query" : queryString
      }
    }
  }
}
