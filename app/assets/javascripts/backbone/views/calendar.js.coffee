class DtimeRumble.Views.Calendar extends Backbone.View
  initialize: ->
    @isMouseDown = false
    @isHighlighted = false
    cal = @
    @$("td").mousedown ()->
      cal.isMouseDown = true
      $(@).toggleClass("highlighted")
      cal.isHighlighted = $(@).hasClass("highlighted")
      $('input', @).attr("checked", cal.isHighlighted)
      return false # prevent text selection
    .mouseover ()->
      if (cal.isMouseDown)
        $(@).toggleClass("highlighted", cal.isHighlighted)
        $('input', @).attr("checked", cal.isHighlighted)

    $(document).mouseup ()=>
      @isMouseDown = false

