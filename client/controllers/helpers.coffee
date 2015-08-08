Template.registerHelper 'log', (l) ->
    console.log l

Template.registerHelper 'logCollection', (l) ->
    console.log l.fetch()

Template.registerHelper 'formatDate', (date) ->
  console.log moment(date).format('YYYY-MM-DD')
  moment(date).format('YYYY-MM-DD')
