class DtimeRumble.Views.Login extends Backbone.View
  events:
    'keyup .email input': 'checkEmail'
    'change .email input': 'checkEmail'
    'keyup .name input': 'checkName'
    'change .name input': 'checkName'

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
    @setGravatar()
    @debounce ?= _.debounce ()=>
      email =  @$('.email input').val()
      if email != '' && email.match(/.+@.+/)
        $.getJSON("/check_email", {email:email}).done ()=>
          @$('.name').addClass('hidden').hide()
          @$('.new-here').hide()
          @$('.form-actions').hide()
          @$('.welcome-back').fadeIn()
          @$('.form-actions input').val('Sign in').removeClass('disabled').attr('disabled', false)
          @$('.form-actions').fadeIn().done ()->
            @$('.form-actions input').focus()
        .fail ()=>
            @$('.name.hidden').removeClass('hidden').hide().fadeIn()
            @$('.new-here').fadeIn()
            @$('.form-actions').fadeIn()
            @$('.welcome-back').hide()
            @$('.form-actions input').val('Sign up').addClass('disabled').attr('disabled', true)
      else
        @$('.name').addClass('hidden').hide()
        @$('.new-here').hide()
        @$('.form-actions').hide()
        @$('.welcome-back').hide()
        @$('.form-actions input').val('Sign in').addClass('disabled').attr('disabled', true)
        @$('.form-actions').fadeOut()
    , 100
    @debounce()
    true

  checkName: ()->
    @debounceName ?= _.debounce ()=>
      if @$('.name').is(":hidden")
        @$('.form-actions input').val('Sign in').removeClass('disabled').attr('disabled', false)
      else if @$(".name input").val() != ''
        @$('.form-actions input').removeClass('disabled').attr('disabled', false)
      else
        @$('.form-actions input').addClass('disabled').attr('disabled', true)

    , 200
    @debounceName()
