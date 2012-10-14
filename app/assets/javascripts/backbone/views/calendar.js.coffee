class DtimeRumble.Views.Calendar extends Backbone.View
  events:
    'mouseover td': 'highlight'
    'mousedown tr': 'start'
    'mousedown img': 'start'
    'click tbody tr th': 'click_row'
    'change input.check': 'highlightThis'
    'mouseup': 'stop'
  initialize: ->
    @isMouseDown = false
    @isHighlighted = false
    @$('td input').css(display: "none")
    @$('input.check').each (i)->
      $(i).closest("td").removeClass("highlighted")
    @$('input.check').filter(":checked").each (i)->
      $(i).closest("td").addClass("highlighted")
    if(@$('.table_wrapper tbody').hasClass("masked"))
      first = @$('.table_wrapper:last').find('td.valid,td.highlighted').first().position()
      @$('.table_wrapper:last').scrollTop(first.top - 30)
    else
      @$('.table_wrapper:last').scrollTop(1300)
    $(document).mouseup _.bind(@stop, @)
    @$el.data("view", @)

  normalize: ()->
    @$('input.check').attr("checked", false)
    @$('.highlighted input.check').attr("checked", true)

  start: (e)->
    target = $(e.target).closest("td")
    @do_touch(target, true)
    return false # prevent text selection

  stop: ->
    @isMouseDown = false
    @isHighlighted = false

  click_row: (e)->
    return unless $(e.target).is("th") || $(e.target).parent().is("th")
    target = $(e.target).closest("tr")
    checks = target.find("input.check")
    return unless checks.length > 0
    is_on = checks.first().is(":checked")
    if is_on
      checks.attr("checked", false)
    else
      checks.attr("checked", true)
    checks.change()
  highlight: (e)->
    target = $(e.target)
    @do_touch(target)

  # Magic to actual handle click/drag events
  do_touch: (target, started = false)->
    @isMouseDown = true if started
    return unless @isMouseDown
    if target.is("td:has(input.check)")
      if started
        checked = target.find("input.check").is(":checked")
        target.find("input.check").attr("checked", !checked) # toggle
        target.find("input.check").change()
        @isHighlighted = !checked
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
