revertFileNameFormat = (fileName) ->
  fileName.replace /\+/g, ' '

uploadFiles = (files, tourID) ->
  uploads = []
  new Promise (resolve, reject) ->
    resolve() if not files.length
    _.each files, (file, i) ->
      uploads.push new Promise (transferred, failed) ->
        S3.upload
          file       : file
          unique_name: false
          path       : tourID
          (error, response) ->
            if error
              failed error
            else
              transferred null
    Promise.all(uploads)
      .then (errors) ->
        _errors = _.without errors, null
        if _errors.length
          reject _errors[0]
        else
          resolve null

formFiles = ($form) ->
  files = []
  _.each $form.find("[type='file']"), (file) ->
    if file.files[0] then files.push(file.files[0])
  files

formatFileName = (file, reverse=false) ->
  if reverse
    file.replace(/\+/g, ' ')
  else
    file.files[0]?.name.split(' ').join '+'


deleteFile = (fileName, tourID, obj, objProp) ->
  new Promise (resolve, reject) ->
    _fileName = revertFileNameFormat fileName
    S3.delete "/#{tourID}/#{_fileName}", (error) ->
      if error
        reject error
      else
        obj.set objProp, null
        obj.save resolve

module.exports =
  uploadFiles   : uploadFiles
  formFiles     : formFiles
  formatFileName: formatFileName
  deleteFile    : deleteFile
