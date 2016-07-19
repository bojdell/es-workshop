/**
*	Write your solution to Challenge 1 in this file
*/
function generateEsQuery(queryString, selectedUser) {
  return {
    "query": {
      "query_string" : {
        "query" : queryString
      }
    }
  }
}
