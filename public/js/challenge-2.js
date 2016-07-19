/**
*	Write your solution to Challenge 2 in this file
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
