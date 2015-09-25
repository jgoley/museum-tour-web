Template.registerHelper 'log', (l) ->
    console.log l

Template.registerHelper 'logCollection', (l) ->
    console.log l.fetch()

Template.registerHelper 'formatDate', (date) ->
  moment(date).format('YYYY-MM-DD')

Template.registerHelper 'awsUrl', ->
  '//s3.amazonaws.com/tap-cma'
