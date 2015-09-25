@Tap = @Tap or {}

@Tap.services =
  showNotification: (error) ->
    if error
        @error()
      else
        @success()
  removeNotification: ->
    setTimeout (->
      $('.notification').fadeOut(-> $(@).remove())
    ), 1300
  error: () ->
    $('body').prepend($("<div class='notification error'></div>").fadeIn())
    @removeNotification()
  success: () ->
    classes = ['thumbs', 'spock', 'peace', 'airplane', 'battery', 'cake', 'smile', 'star', 'trophy']
    ran = Math.floor (Math.random() * 9)
    $('body').prepend($("<div class='notification success #{classes[ran]}'></div>").fadeIn())
    @removeNotification()


