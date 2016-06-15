require '../views/stop_data.jade'

Template.stopData.helpers
  isUpdating : () ->
    Session.get('updating'+@stop._id)

  formatFile : () ->
    @stop.media.split(' ').join('+')
