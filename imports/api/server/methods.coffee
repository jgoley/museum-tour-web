{ showNotification } = require '../../helpers/notifications'
{ go }               = require '../../helpers/route_helpers'

Meteor.methods
  deleteTour: (id) ->
    Tour.remove id

  # uploadFile: (files, tour) ->
  #   new Promise (resolve, reject) ->
  #     S3.upload
  #       files:files
  #       unique_name: false
  #       path: tour
  #       (e,r) ->
  #         console.log e, r
  #         resolve(r)

  saveStop: (stop, values, method) ->
    if method is 'update'
      if stop.type is 'single'
        sessionString = stop._id
      else
        sessionString = "child-" + stop.parent + '-' + stop._id
        #update ord of stops higher than edited stop
          # if stop.order != values.values.order
          #   siblings = TourStop().find({$and: [
          #     { parent: stop.parent }
          #     { _id: $ne: stop._id }
          #     { order: $gte: +values.values.order }
          #   ]}).fetch()
          #   _.each siblings, (sibling, i) ->
          #     TourStop().update {_id: sibling._id}, {$set: {order: sibling.order + 1}}, (e,r) ->

      stop.set values.values
      TourStop.update {_id: stop._id}, {$set:values.values}, (e,r) ->

          # setTimeout (->
            #   Session.set('updating'+stop._id, false)
            #
            #   return
            # ), 2000
    else
      stop = new Stop()
      stop.set values.values
      stop.save ->

      # TourSto().insert values.values, (e, id) ->
        #   Session.set('add-stop', false)
        #   Session.set('creating-stop', false)
        #   parent = values.values.parent
        #   Session.set(id,true)
        #   if values.values.type is 'child'
        #     Session.set('add-child-'+parent, false)

  deleteFile: (stop)->
    path = "#{stop.tour}/#{stop.media}"
    S3.delete path, (e,s)-> console.log e,s
    stop.set media: ''
    stop.save()
    # TourSto().update({_id: stop._id}, {$set:{media: ''}})

  deleteFolder: (tourID) ->
    path = "#{tourID}"
    S3.delete path, (e,s)-> console.log e,s

  removeGroup: (childStops) ->
    _.each childStops, (childStopId) ->
      childStop TourStop().findOne({_id:childStopId})
      if childStop.media
        deleteFile(childStop)
      removeStop(@id, Template.instance())
    TourStop.remove @_id

  removeStop: (stopID, template) ->
    stopNumber = @stopNumber
    higherStops = _.filter template.data.stops.fetch(), (stop) ->
      stop.stopNumber > stopNumber
    _.each higherStops, (stop) ->
      TourStop.update {_id: stop._id}, {$set: {stopNumber: stop.stopNumber-1}}
    TourStop.remove({_id: stopID})

  updateTitle: (stop, title) ->
    stop.set title: title
    stop.save()

  deleteMedia: (prop, fileName, stopID, tourID)->
    path = "/#{tourID}/#{fileName}"
    S3.delete(path, (e,s)-> console.log e,s)
    newProp = {}
    newProp[prop] = ''
    if stopID
      TourStop().update({_id: stopID}, {$set:newProp})
    else
      Tour().update({_id: tourID}, {$set:newProp})

  deleteTourImage: (tour)->
    path = "/#{tour.tourID}/#{tour.image}"
    S3.delete(path, (e,s)-> console.log e,s)
    Tour.update({_id: tour.tourID}, {$set:{image: ''}})

  upload: (files) ->
    S3.upload
      files:files
      unique_name: false
      path: 'media'
      (e,r) ->
        console.log(e,r)

  uploadFile: (files, tourID, values, redirect, template) ->
    if files.length > 0
      S3.upload
        files:files
        unique_name: false
        path: tourID
        (e,r) ->
          console.log e,r
          if e
            alert("Something went wrong with the upload. Are you connected to the interwebs?")
          else
            if redirect
              go '/admin/edit/'+tourID
            else
              Tour.update {_id: tourID}, {$set: values}, (e) ->
                showNotification(e)
