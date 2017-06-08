fetchBroadcastInfo = ->
  statusElement = document.getElementById('player-status')
  titleElement = document.getElementById('player-title')
  detailsElement = document.getElementById('player-details')
  spaceElement = document.getElementById('player-space')
  pictureElement = document.getElementById('player-picture')
  defaultPictureElement = document.getElementById('player-default-picture')

  # https://www.sitepoint.com/guide-vanilla-ajax-without-jquery/
  request = new XMLHttpRequest

  request.onload = ->
    info = JSON.parse(request.response)
    statusElement.innerHTML = info.status
    titleElement.innerHTML = info.title
    if info.link == null
      detailsElement.style.display = 'none'
      spaceElement.style.display = 'none'
    else
      detailsElement.href = info.link
      detailsElement.style.display = 'inline'
      spaceElement.style.display = 'inline'

    if info.pic != null
      defaultPictureElement.style.display = 'none'
      pictureElement.src = info.pic
      pictureElement.style.display = 'block'
    else
      pictureElement.style.display = 'none'
      defaultPictureElement.style.display = 'block'
    return

  bustCache = '?' + (new Date).getTime()
  request.open 'GET', 'https://old.studio.freshair.org.uk/api/broadcast_info/' + bustCache, true
  request.responseType = 'json'
  request.send()
  return


initializePlayer = ->

  fetchBroadcastInfo()

  # https://github.com/turbolinks/turbolinks/issues/157
  radio = new Audio('https://studio.freshair.org.uk:8443/radio')

  ctrl = document.getElementById('audio-control')
  ctrl_txt = document.getElementById('audio-control-txt')
  play_icon = document.getElementById('play-icon')


  ctrl.onclick = ->
    if radio.paused
      radio.play()
      ctrl_txt.innerHTML = 'Pause'
      play_icon.innerHTML = '<i class="fa fa-pause" aria-hidden="true"></i>'
    else
      radio.pause()
      ctrl_txt.innerHTML = 'Play now'
      play_icon.innerHTML = '<i class="fa fa-play" aria-hidden="true"></i>'
    return

$(document).ready(initializePlayer);

setInterval (->
  fetchBroadcastInfo()
  return
), 3000
