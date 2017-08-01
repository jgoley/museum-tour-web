import '../views/stop_content.jade'
import '../../components/videoContent/videoContent.coffee'

Template.stopContent.helpers
  isVideoContent: ->
    stop = Template.instance().data.stop
    stop?.isVideo() or stop?.isAudio()
