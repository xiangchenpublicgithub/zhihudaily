_ = require "underscore"
request = require "request"
async = require "async"
getToken = require("./tietu").getToken
crawler = {}

crawler.getData = (url, cb, times = 0) ->
  request url, (err, response, body) ->
    if err
      times += 1
      if times < 5
        return crawler.getData url, cb, times
      else
        return cb err
    return cb null, JSON.parse body

crawler.postData = (url, form, cb, times = 0) ->
  request.post url, form, (err, response, body) ->
    if err
      times += 1
      if times < 5
        return crawler.postData url, form, cb, times
      else
        return cb err
    return cb null, JSON.parse body

crawler.upImage = (storyObj, cb)->
  imageUrls = storyObj.body.match /https?:\/\/\S+?zhimg\.com\/\S+?\.(?:jpg|png|gif)/g
  imageUrls = [] if imageUrls == null
  imageUrls.push storyObj.image
  imageUrls = _.uniq imageUrls

  token = getToken()
  async.map imageUrls, ((imageUrl, callback)->
    crawler.postData require("../config").tietuku.url,
      form:
        Token: token
        fileurl: imageUrl
    , (err, body) ->
      if err or body.code
        callback null
      else
        callback null, [imageUrl, body.linkurl]
  ), (err, results) ->
    return cb err if err
    if results.length is 0
      return cb null, storyObj
    for result in results
      if result
        storyObj.body = storyObj.body.replace(result[0],result[1])
        storyObj.image = storyObj.image.replace(result[0],result[1])
    return cb null, storyObj

module.exports = crawler
