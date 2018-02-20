import { Asset } from '../../assets/index'

Meteor.publish 'helpVideoAssets', (names) ->
  Asset.find(name: $in: ['help-video', 'help-video-poster'])
