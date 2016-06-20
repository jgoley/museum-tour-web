require '../views/stop_data.jade'

Template.stopData.helpers
  isUpdating : () ->
    Template.instance().data.uploading.get()
