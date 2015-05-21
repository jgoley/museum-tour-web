AutoForm.debug()

Template.registerHelper 'group', (val) ->
    console.log $(val).value
    AutoForm.getFieldValue "createTour", fieldName || false

hooks = {
  onSubmit: (insertDoc, updateDoc, currentDoc) ->
    files = _.map $("input[type=file]"), (file)->
      file.files[0]
    console.log insertDoc
    if files
      S3.upload
        files:files
        unique_name: false
        path: insertDoc.mainTitle.replace(' ', '-')
        (e,r) ->
          console.log(e,r)
          return
      Tours.insert insertDoc
      @done()
      false
    else 
      Tours.insert insertDoc
      @done()
      false
}

# AutoForm.addHooks('createTour', hooks);

Template.createTour.helpers
  "files": () ->
    S3.collection.find()
