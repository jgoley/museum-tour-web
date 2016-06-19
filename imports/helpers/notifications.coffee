showNotification = (error) ->
  Session.set 'notifying', true
  message = ''
  if error
    notificationClasses = 'error'
    message = error.message
  else
    classes = ['thumbs', 'spock', 'peace', 'cake', 'smile', 'star', 'trophy']
    randomNum = Math.floor (Math.random() *7)
    notificationClasses = "success #{classes[randomNum]}"

  $('body').prepend($("<div class='notification #{notificationClasses}'>#{message}</div>").fadeIn())
  removeNotification()

killNotification = ->
  Session.set 'notifying', false
  $('.notification').fadeOut(-> $(@).remove())

removeNotification = ->
  $(window).on 'click', ->
    killNotification()
  $(window).keyup ->
    killNotification()

  setTimeout (->
    killNotification()
    $(window).off 'click', 'keyup'
  ), 1300

module.exports =
  showNotification: showNotification
  removeNotification: removeNotification
