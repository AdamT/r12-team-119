class DtimeRumble.Views.Calendar extends Backbone.View
  events:
    if $('html').hasClass('touch')
      {
        'touchstart': 'touchstart'
        'touchstop': 'stop'
        'touchmove': 'touchhighlight'
      }
    else
      {
        'mouseover td': 'highlight'
        'mousedown': 'start'
        'mouseup': 'stop'
      }
  initialize: ->
    @isMouseDown = false
    @isHighlighted = false
    $(document).mouseup ()=>
      @isMouseDown = false

  touchstart: (e)->
    target = $(e.touches)
    @isMouseDown = true
    if target.is("td")
      target.toggleClass("highlighted")
      @isHighlighted = target.hasClass("highlighted")
    else
      @isHighlighted = true
    $('input', target).attr("checked", @isHighlighted)
    # return false # prevent text selection

  start: (e)->
    target = $(e.target)
    @isMouseDown = true
    if target.is("td")
      target.toggleClass("highlighted")
      @isHighlighted = target.hasClass("highlighted")
    else
      @isHighlighted = true
    $('input', target).attr("checked", @isHighlighted)
    return false # prevent text selection

  stop: ->
    @isMouseDown = false

  highlight: (e)->
    target = $(e.target)
    if @isMouseDown  && target.is("td")
      $(target).toggleClass("highlighted", @isHighlighted)
      $('input', target).attr("checked", @isHighlighted)
  touchhighlight: (e)->
    alert 'hi'
    target = $(e.touches).filter("td")
    if @isMouseDown  && target.is("td")
      $(target).toggleClass("highlighted", @isHighlighted)
      $('input', target).attr("checked", @isHighlighted)
