export default class FetchError extends Error {
  /**
   * @param {Response} response 
   * @param {object} responseBody 
   */
  constructor(response, responseBody) {
    super(`Request failed with ${response.statusText}`)

    this.response = response;
    this.responseBody = responseBody;
  }
}
