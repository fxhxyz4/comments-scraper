do ->
  input = document.getElementById('url')
  form = document.querySelector('.form')
  btn = document.querySelector('.btn')
  api = document.getElementById('api')

  api.value = localStorage.getItem('API_KEY')

  DATE = new Date().toISOString().split('T')[0]
  TOP_STRING = ""

  API_KEY = ''
  BASE_URL = 'https://www.googleapis.com/youtube/v3/commentThreads?part=snippet,replies&'

  form.addEventListener 'submit', (e) ->
    e.preventDefault()

    localStorage.setItem('API_KEY', api.value.trim())

    API_KEY = localStorage.getItem('API_KEY')

    videoUrl = input.value.trim()
    include = 'youtube.com'

    unless videoUrl.includes(include)
      console.error('type a valid yt url')
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
    topComments = comments.map (i) ->
      { authorDisplayName, textOriginal, likeCount } = i.snippet.topLevelComment.snippet
      cleanedText = textOriginal.replace(/\n/g, '')

      TOP_STRING += "#{authorDisplayName},#{cleanedText},#{likeCount}"
      TOP_STRING += "\n"

  processThreadReplies = (replies) ->
    topReplies = replies.comments.map (i) ->
      { authorDisplayName, textOriginal, likeCount } = i.snippet
      cleanedText = textOriginal.replace(/\n/g, '')

      TOP_STRING += "#{authorDisplayName},#{cleanedText},#{likeCount}"
      TOP_STRING += "\n"

  getVideoIdFromUrl = (url) ->
    return new Promise (resolve, reject) ->
      videoId = new URLSearchParams(new URL(url).search).get('v')
      resolve(videoId)

  saveAndDownload = () ->
    filename = "comments-#{DATE}.csv"
    blob = new Blob([TOP_STRING], { type: 'text/csv' })

    url = URL.createObjectURL(blob)

    chrome.downloads.download
      url: url
      filename: filename
      saveAs: true
