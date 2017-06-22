import './media_types.jade'

Template.mediaTypes.helpers
  stopTypesForm: () ->
    [
      {label: 'Audio', value: 1},
      {label: 'Video', value: 2},
      {label: 'Picture', value: 3},
      {label: 'Music', value: 4},
      {label: 'Film', value: 5}
    ]
  selected : (stop) ->
    if stop and @value is +stop.mediaType
      'selected'

Template.mediaTypes.events
  'change .media-type-select': (event, instance) ->
    mediaType = instance.data.mediaType
    value = event.target.value

    if @stop and @stop.mediaType == mediaType.get()
      change = confirm """
        Changing the media type will most likely require uploading a new file.
        Continue with change?
        """
      if change
        mediaType.set value
    else
      mediaType.set value
