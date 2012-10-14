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
        'mousedown tr': 'start'
        'mousedown img': 'start'
        'change input.check': 'highlightThis'
        'mouseup': 'stop'
      }
  initialize: ->
    @isMouseDown = false
    @isHighlighted = false
    @$('input.check:checked').each (i)->
      $(i).closest("td").addClass("highlighted")
    if(@$('.table_wrapper tbody').hasClass("masked"))
      first = @$('.table_wrapper:last').find('td.valid,td.highlighted').first().position()
      @$('.table_wrapper:last').scrollTop(first.top - 30)
    else
      @$('.table_wrapper:last').scrollTop(1300)

    $(document).mouseup _.bind(@stop, @)

  touchstart: (e)->
    target = $(e.touches)
    @do_touch(target, true)
    # return false # prevent text selection

  start: (e)->
    target = $(e.target).closest("td")
    @do_touch(target, true)
    return false # prevent text selection

  stop: ->
    @isMouseDown = false
    @isHighlighted = false

  highlight: (e)->
    target = $(e.target)
    @do_touch(target)

  touchhighlight: (e)->
    target = $(e.touches).filter("td")
    @do_touch(target)

  # Magic to actual handle click/drag events
  do_touch: (target, started = false)->
    @isMouseDown = true if started
    return unless @isMouseDown
    if target.is("td:has(input.check)")
      if started
        target.toggleClass("highlighted")
        @isHighlighted = target.hasClass("highlighted")
    else
      @isHighlighted = true if started
    $('input.check', target).attr("checked", @isHighlighted)
    $('input.check', target).change()

  highlightThis: (e)->
    target = $(e.target)
    if target.is(":checked")
      target.closest('td').addClass("highlighted")
    else
      target.closest('td').removeClass("highlighted")
