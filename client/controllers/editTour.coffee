TourStops = () ->
  @Tap.Collections.TourStops  
Tours = () ->
  @Tap.Collections.Tours

Template.editTour.helpers
  settings: () ->
    fields: ['stopNumber','title', 'type','mediaType' ]
  editStop: () ->
    Session.get("TargetValue" + this._id);
  tours: () ->
    Tours()
  tourStops: () ->
    TourStops()

Template.editTour.events
  'dblclick .tour-stops tr' : (e) ->
    Session.set("TargetValue" + this._id,true)
  'click .cancel': (e)->
    Session.set("TargetValue" + this._id,false)
  'click .save': (e)->
    inputs = $(e.target).parent().find('input').get()
    values = {}

    _.each inputs, (input)->
      values[input.name] = input.value

    console.log values

    TourStops().update({_id: this._id}, {$set:values})
    Session.set("TargetValue" + this._id,false)

  'click .show-children': (e)->
    $('.childStops-'+this.stopNumber).toggleClass('hidden')