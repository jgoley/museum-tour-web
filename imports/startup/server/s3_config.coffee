S3.config =
  key: Meteor.settings.private.s3.key
  secret: Meteor.settings.private.s3.secret
  bucket:  Meteor.settings.private.s3.bucket

S3.rules.delete = () ->
  Meteor.userId()
