# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ()->
  isMouseDown = false
  isHighlighted = false
  $("table td").mousedown ()->
      isMouseDown = true
      $(this).toggleClass("highlighted")
      isHighlighted = $(this).hasClass("highlighted")
      $('input', this).attr("checked", isHighlighted)
      return false # prevent text selection
  .mouseover ()->
    if (isMouseDown)
      $(this).toggleClass("highlighted", isHighlighted)
      $('input', this).attr("checked", isHighlighted)

  $(document).mouseup ()->
    isMouseDown = false

