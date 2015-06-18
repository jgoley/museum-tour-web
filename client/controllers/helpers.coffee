Template.registerHelper 'log', (l) ->
    console.log l

Template.registerHelper 'logCollection', (l) ->
    console.log l.fetch()
