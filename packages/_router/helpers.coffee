go = (pathDef, params, queryParams) ->
  FlowRouter.go pathDef, params, queryParams

setParams = (params) ->
  FlowRouter.setParams(params)

# From the arillo:meteor-flow-router-helpers package
Template.registerHelper 'pathFor', (path, view = {hash:{}}) ->
  throw new Error('no path defined') unless path
  # set if run on server
  view = hash: view unless view.hash
  if path.hash?.route?
    view = path
    path = view.hash.route
    delete view.hash.route
  query = if view.hash.query then FlowRouter._qs.parse(view.hash.query) else {}
  hashBang = if view.hash.hash then view.hash.hash else ''
  FlowRouter.path(path, view.hash, query) + hashBang

