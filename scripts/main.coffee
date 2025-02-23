do ->
  input = document.getElementById('url')
  form = document.querySelector('.form')
  btn = document.querySelector('.btn')
  api = document.getElementById('api')

  api.value = localStorage.getItem('API_KEY')

  DATE = new Date().toISOString().split('T')[0]
  TOP_STRING = ''

  regexShort = /(?:youtube\.com\/shorts\/)([a-zA-Z0-9_-]{11})/
  regexVideo = /(?:youtube\.com\/watch\?v=)([a-zA-Z0-9_-]{11})/

  API_KEY = ''
  BASE_URL = 'https://www.googleapis.com/youtube/v3/commentThreads?part=snippet,replies&'

  commentAuthors = {}

  form.addEventListener 'submit', (e) ->
    e.preventDefault()

    localStorage.setItem('API_KEY', api.value.trim())

    API_KEY = localStorage.getItem('API_KEY')

    videoUrl = input.value.trim()
    include = 'youtube.com'

    unless videoUrl.includes(include)
      console.error('Type a valid yt url')
      return

    form.reset()
    fetchData videoUrl

  fetchData = (videoUrl) ->
    getVideoIdFromUrl(videoUrl)
      .then (videoId) ->
        nextPageToken = null
        comments = []

        fetchComments = ->
          url = "#{BASE_URL}videoId=#{videoId}&key=#{API_KEY}"
          url += "&pageToken=#{nextPageToken}" if nextPageToken
          url += "&maxResults=100"

          fetch(url)
            .then (r) -> r.json()
            .then (d) ->
              items = d.items
              nextToken = d.nextPageToken

              comments.push items...

              if nextToken
                nextPageToken = nextToken
                fetchComments()
              else
                processThread(comments)

        fetchComments()

  processThread = (comments) ->
    processThreadComments(comments)

    for comment in comments
      if comment.snippet.totalReplyCount
        { replies } = comment
        processThreadReplies(replies)

    saveAndDownload()

  processThreadComments = (comments) ->
    comments.map (i) ->
      { id, snippet } = i
      { authorDisplayName, textOriginal, likeCount } = snippet.topLevelComment.snippet

      cleanedText = textOriginal.replace(/\n/g, '').replaceAll(",", ". ")

      commentAuthors[id] = {
        name: authorDisplayName,
        id: id
      }

      TOP_STRING += "#{authorDisplayName},#{cleanedText},like: #{likeCount}"
      TOP_STRING += "\n"

  processThreadReplies = (replies) ->
    replies.comments.map (i) ->
        { authorDisplayName, textOriginal, likeCount, parentId } = i.snippet
        cleanedText = textOriginal.replace(/\n/g, '').replaceAll(",", ". ")

        if commentAuthors[parentId]
            parentAuthor = commentAuthors[parentId].name
            parentId = commentAuthors[parentId].id
        else
            parentAuthor = 'Undefined'
            parentId = 'Undefined'

        TOP_STRING += "#{authorDisplayName},#{cleanedText},like: #{likeCount},replyTo: #{parentAuthor},replyId: #{parentId}"
        TOP_STRING += "\n"

  getVideoIdFromUrl = (url) ->
    return new Promise (resolve, reject) ->
      matchShort = url.match(regexShort)
      matchVideo = url.match(regexVideo)

      if matchShort && matchShort[1]
        resolve(matchShort[1])
      else if matchVideo && matchVideo[1]
        resolve(matchVideo[1])
      else
        reject('Unable to extract video ID from URL')

  saveAndDownload = () ->
    filename = "comments-#{DATE}.csv"
    blob = new Blob([TOP_STRING], { type: 'text/csv' })

    url = URL.createObjectURL(blob)

    chrome.downloads.download
      url: url
      filename: filename
      saveAs: true
