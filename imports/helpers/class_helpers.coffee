revertFileNameFormat = (fileName) ->
  fileName.replace /\+/g, ' '

module.exports =
  revertFileNameFormat: revertFileNameFormat
