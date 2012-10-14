class DtimeRumble.Views.Login extends Backbone.View
  events:
    'change .email input': 'checkEmail'
    'keyup .email input': 'setGravatar'

  initialize: ->
    @$('.form-actions').hide()
    @$el.data("view", @)

  setGravatar: ->
    @throttled ?= _.throttle ()=>
      email = @$('.email input').val()
      hash = hex_md5(email)
      @$('.gravatar img').attr('src', "//www.gravatar.com/avatar/#{hash}").show()
    , 250
    @throttled()

  checkEmail: (e)->
    $.getJSON("/check_email", {email: $(e.currentTarget).val()}).done ()=>
      #nop
      @setGravatar()
      @$('.name').addClass('hidden')
      @$('.new-here').hide()
      @$('.form-actions').show()
      @$('.form-actions input').val('Sign in')
    .fail ()=>
      @$('.name.hidden').removeClass('hidden')
      @$('.new-here').show()
      @$('.form-actions').show()
      @$('.form-actions input').val('Sign up')

