define([
  'jq'
  'underscore'
  'Backbone'
  'views/shared/alert_message'
  'text!templates/vendor/rooms/form_layout.html'
], ($
    _
    Backbone
    AlertMessage
    FormLayoutTemplate
  )->
    FormLayoutView = Backbone.View.extend(
      tagName: 'div'
      className: 'row'

      events:
        'click .cancelLayout': 'cancelLayout'
        'click .saveLayout': 'saveLayout'
        'click .deleteLayout': 'deleteLayout'

      cancelLayout: (e)->
        e.preventDefault()
        e.stopPropagation()
        $e = $(e.currentTarget)
        @$el.remove()


      saveLayout: (e)->
        that = this
        e.preventDefault()
        e.stopPropagation()
        $e = $(e.currentTarget)
        console.log @formLayout.toJSON()

        isNew = @formLayout.isNew()
        if isNew
          @formLayout.url = '/api/rooms/layouts/add'
        else
          @formLayout.url = '/api/rooms/layouts/update'

        @formLayout.save @formLayout.toJSON(),
          success: (model, response, options)->
            if isNew
              that.layouts.add that.formLayout
            msg = new AlertMessage({type: 'success', messages: ["Room was saved successfully."]})
            that.$el.prepend(msg.render().el)

          error: (model, response, options)->
            msg = new AlertMessage({messages: ["There are some errors"]})
            that.$el.prepend(msg.render().el)        

      deleteLayout: (e)->
        e.preventDefault()
        e.stopPropagation()
        $e = $(e.currentTarget)
        @$el.remove()


      initialize: (options)->
        @formLayout = options.formLayout
        @layouts = options.layouts

      bindingDom: ()->
        @$name = @$('input[name="name"]')
        @$name.on 'blur', => 
          @formLayout.set name: @$name.val()

        @$productType = @$('select[name="productType"]')
        @$productType.on 'change', => 
          @formLayout.set productType: @$productType.val()

        @$maxGuest = @$('input[name="maxGuest"]')
        @$maxGuest.on 'change', => 
          @formLayout.set maxGuest: @$maxGuest.val()    

        @$minHour = @$('input[name="minHour"]')
        @$minHour.on 'change', => 
          @formLayout.set minHour: @$minHour.val()        

        @$description = @$('textarea[name="description"]')
        @$description.on 'change', => 
          @formLayout.set description: @$description.val()        

      render: ()->
        that = this
        tpl = _.template(FormLayoutTemplate, {_: _, layout: @formLayout.toJSON()})
        @$el.html(tpl)
        @bindingDom()
        @

    )
    return FormLayoutView

)