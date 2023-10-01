do ->
  input = document.getElementById('url')
  form = document.querySelector('.form')

  API_KEY = 'YOUR-API-KEY'
  BASE_URL = 'https://www.googleapis.com/youtube/v3/commentThreads?part=snippet&videoId'

  form.addEventListener 'submit', (e) ->
    e.preventDefault()

    videoUrl = input.value.trim()
    include = 'youtube.com'

    unless videoUrl.includes(include)
      console.error('type a valid yt url')
      return

    form.reset()
    fetchData videoUrl

  fetchData = (videoUrl) ->
    videoId = getVideoIdFromUrl videoUrl
    date = new Date().toISOString().split('T')[0]

    nextPageToken = null
    comments = []

    fetchComments = ->
      url = "#{BASE_URL}=#{videoId}&key=#{API_KEY}"
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
            do fetchComments
          else
            topStrings = comments.map (item) ->
              {authorDisplayName, textOriginal, likeCount} = item.snippet.topLevelComment.snippet
              cleanedText = textOriginal.replace(/\n/g, '')
              "#{authorDisplayName},#{cleanedText},#{likeCount}"
            .join('\n')

            saveAndDownload topStrings, date

    do fetchComments

  getVideoIdFromUrl = (url) ->
    new URLSearchParams(new URL(url).search).get('v')

  saveAndDownload = (comments, date) ->
    filename = "comments-#{date}.csv"
    blob = new Blob([comments], { type: 'text/csv' })

    url = URL.createObjectURL(blob)

    chrome.downloads.download
      url: url
      filename: filename
      saveAs: true
