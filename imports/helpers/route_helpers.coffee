go = (pathDef, params, queryParams) ->
  FlowRouter.go pathDef, params, queryParams

setParams = (params) ->
  FlowRouter.setParams(params)

module.exports =
  go: go
  setParams: setParams
