@Tap = @Tap or {}

@Tap.services =
  showNotification: (error, sessionString, editing) ->
    if error
        @error()
      else
        @success(sessionString, editing)
  removeNotification: (sessionString, editing) ->
    setTimeout (->
      Session.set sessionString, false
      if editing then editing.set(false)
      $('.notification').fadeOut(-> $(@).remove())
    ), 1300
  error: () ->
    $('body').prepend($("<div class='notification error'></div>").fadeIn())
    @removeNotification()
  success: (sessionString, editing) ->
    classes = ['thumbs', 'spock', 'peace', 'cake', 'smile', 'star', 'trophy']
    ran = Math.floor (Math.random() *7)
    $('body').prepend($("<div class='notification success #{classes[ran]}'></div>").fadeIn())
    @removeNotification(sessionString, editing)


