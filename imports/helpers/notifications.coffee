showNotification = (error) ->
  Session.set 'notifying', true
  console.log error
  message = ''
  classes = {}
  dismiss = ''

  if error
    classes =
      type: 'error'
      icon: 'caution'
    if _.isObject error
      message = error.message
    else
      message = error
    dismiss = '<i class="fa fa-times-circle"></i>'

  else
    classes = ['thumbs', 'spock', 'peace', 'cake', 'smile', 'star', 'trophy']
    randomNum = Math.floor (Math.random() *7)
    classes =
      type: 'success'
      icon: "#{classes[randomNum]}"

  $('body').prepend(
    """
      <div class='notification #{classes.type}'>
        <div class='content #{classes.icon}'>
          <p>#{message}</p>
          #{dismiss}
        </div>
      </div>
    """
    ).fadeIn()
  removeNotification(error)

killNotification = ->
  Session.set 'notifying', false
  $('.notification').fadeOut(-> $(@).remove())
  $(window).off 'click', 'keyup'

removeNotification = (error) ->
  $(window).on 'click', ->
    killNotification()
  $(window).keyup ->
    killNotification()

  time = if error then 2000 else 250

  unless error
    setTimeout (->
      killNotification()
      $(window).off 'click', 'keyup'
    ), time

module.exports =
  showNotification: showNotification
  removeNotification: removeNotification
