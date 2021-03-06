define([
  'jq'
  'underscore'
  'Backbone'
  'models/venue'
  'views/shared/alert_message'
  'text!templates/vendor/setup/venue.html'
], ($, _, Backbone, VenueModel, AlertMessage, SetupVenueTemplate)->

  VenueSetupView = Backbone.View.extend(
    tagName: 'div'
    className: 'row'
    events:
      'click .cancelVenue': 'cancelVenue'
      'click .updateVenue': 'updateVenue'
      # 'click .deleteVenue': 'deleteVenue'

    cancelVenue: (e)->
      e.preventDefault()
      e.stopPropagation()
      @venue = @model.clone()
      @buildHtml()

    updateVenue: (e)->
      e.preventDefault()
      e.stopPropagation()
      if @venue.isValid()
        @venue.url = '/api/venues/mine'
        @venue.save()
        @model = @venue.clone()
        msg = new AlertMessage({type: 'success', messages: ["Venue was updated successfully."]})
        @$el.prepend(msg.render().el)
      else
        msg = new AlertMessage({messages: ["There are some errors"]})
        @$el.prepend(msg.render().el)

    deleteVenue: (e)->
      e.preventDefault()
      e.stopPropagation()
      console.log @venue.toJSON()
      console.log @venue.isNew()


    initialize: (options={})->
      that = this
      that.options = options || {}
      that.venue = new VenueModel()
      that.model = that.venue
      that.venue.url = '/api/venues/mine'
      @initConstant()

    initConstant: ->
      @BUSINESS_HOURS = 
        OPEN: 
          5: '5:00a'
          6: '6:00a'
          7: '7:00a'
          8: '8:00a'
          9: '9:00a'
          10: '10:00a'
        CLOSE:
          19: '7:00p'
          20: '8:00p'
          21: '9:00p'
          22: '10:00p'
          23: '11:00p'

      @TIME_ZONES =
        pacific: "Pacific Standard Time"
        easter: "Eastern Standard Time"
        central: "Central Standard Time"

      @CURRENCY =
        USD: "US Dollars"
        EUR: "Euro"

      @CUISINE_TYPES =
        american: "American"
        japanese: "Japanese"
        korean: "Korean"

    bindingDom: ->
      @$name = @$('input[name="name"]')
      @$name.on 'blur', => 
        @venue.set name: @$name.val()

      @$address = @$('input[name="address"]')
      @$address.on 'blur', => 
        @venue.set address: @$address.val()

      @$phone = @$('input[name="phone"]')
      @$phone.on 'blur', => 
        @venue.set phone: @$phone.val()

      @$fax = @$('input[name="fax"]')
      @$fax.on 'blur', => 
        @venue.set fax: @$fax.val()

      @$url = @$('input[name="url"]')
      @$url.on 'blur', => 
        @venue.set url: @$url.val()

      @$email = @$('input[name="email"]')
      @$email.on 'blur', => 
        @venue.set email: @$email.val()

      @$taxInMenu = @$('input[name="taxInMenu"]')
      @$taxInMenu.on 'click', => 
        @venue.set taxInMenu: @$taxInMenu.is(':checked')

      @$tax = @$('input[name="tax"]')
      @$tax.on 'blur', => 
        @venue.set tax: @$tax.val()

      @$gratuity = @$('input[name="gratuity"]')
      @$gratuity.on 'blur', => 
        @venue.set gratuity: @$gratuity.val()

      @$businessHourOpen = @$('select[name="businessHourOpen"]')
      @$businessHourOpen.on 'change', =>
        businessHour = @venue.get('businessHour') || {}
        businessHour.openTime = @$businessHourOpen.val()
        @venue.set 'businessHour': businessHour

      @$businessHourClose = @$('select[name="businessHourClose"]')
      @$businessHourClose.on 'change', => 
        businessHour = @venue.get('businessHour') || {}
        businessHour.closeTime = @$businessHourClose.val()
        @venue.set 'businessHour': businessHour

      @$timeZone = @$('select[name="timeZone"]')
      @$timeZone.on 'change', => 
        @venue.set timeZone: @$timeZone.val()

      @$cuisineType = @$('select[name="cuisineType"]')
      @$cuisineType.on 'change', => 
        @venue.set cuisineType: @$cuisineType.val()

      @$currency = @$('select[name="currency"]')
      @$currency.on 'change', => 
        @venue.set currency: @$currency.val()

    buildHtml: ()->
      that = this
      tpl = _.template(SetupVenueTemplate, 
        _: _
        venue: that.venue.toJSON()
        BUSINESS_HOURS: that.BUSINESS_HOURS
        TIME_ZONES: that.TIME_ZONES
        CURRENCY: that.CURRENCY
        CUISINE_TYPES: that.CUISINE_TYPES
      )
      that.$el.html(tpl)
      @bindingDom()
      @jsValidate()
      
    jsValidate: ()->
      $(document).foundation
        abide:
          live_validate : true
          validate_on_blur : true
          focus_on_invalid : true
          error_labels: true
          timeout : 1000        

    render: ()->
      that = this
      that.venue.fetch 
        success: (v, response, options)->
          that.model = that.venue.clone()
          that.buildHtml()
      @

  )
  return VenueSetupView

)