mongoose = require('mongoose')
LocalStrategy = require('passport-local').Strategy
User = mongoose.model('User')

local = new LocalStrategy(
    usernameField: 'email',
    passwordField: 'password'
  , (email, password, done)->
    options =
      criteria: { email: email }
      select: 'venue name email hashedPassword salt'
    User.load options, (err, user)->
      if err
        return done(err)
      if !user
        return done(null, false, { message: 'Unknown user' })

      if !user.authenticate(password)
        return done(null, false, { message: 'Invalid password' })

      return done(null, user)
)
module.exports = local