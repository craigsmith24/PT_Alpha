express  = require 'express'
router = express.Router()
api = require('../../../libs/authentication')
TagService = require('../../services/tag_service')

module.exports = (app, passport) ->
  app.use '/api/tags', api.requiresLogin, router


  router.get "/search", (req, res)->
    name = req.query.name || req.body.name || ''
    taggable = req.query.taggable || ''
    TagService.search {name: name, taggable: taggable}, (tags)->
      res.json(tags)

  router.post "/add", (req, res)->
    name = req.body.name
    taggable = req.body.taggable
    isValid = TagService.addNew({name: name, taggable: taggable})
    res.json({success: isValid})
