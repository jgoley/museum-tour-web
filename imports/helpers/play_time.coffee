module.exports =
  convertPlayTime = (time) ->
    if not time
      return '00:00'
    sec_num = parseInt(time, 10)
    hours   = Math.floor(sec_num / 3600)
    minutes = Math.floor((sec_num - (hours * 3600)) / 60)
    seconds = sec_num - (hours * 3600) - (minutes * 60)
    if minutes < 10
      minutes = '0' + minutes
    if seconds < 10
      seconds = '0' + seconds
    minutes + ':' + seconds
