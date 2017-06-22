import { Template } from 'meteor/templating'

import './posterImage.jade'

Template.posterImage.helpers
  mediaIsVideo: ->
    @mediaType.get() in [2,'2']
