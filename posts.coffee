@Posts = new Meteor.Collection "posts"

if Meteor.isClient

  # subscribe posts from server
  Meteor.subscribe "posts"

  # create
  Template.postForm.events 
    "click button": (e, t) ->
      firstName = if Meteor.user() then Meteor.user().profile.name else "Guest"
      data = t.find "#content"
      Posts.insert {content: data.value, firstName: firstName, time: Date.now()} if data.value isnt ""
      data.value = ""
  
  # Read
  Template.posts.post = ->
    Posts.find({}, { sort: time: -1})

  # update
  Template.post.editing = ->
    Session.get "target" + @_id
  
  Template.post.events
    "click #edit": (e, t) ->
      Session.set "target" + t.data._id, true

    "keypress input": (e, t) ->
      if e.keyCode is 13 && e.currentTarget.value isnt ""
        post = Posts.findOne(t.data)
        Posts.update {_id: post._id}, { $set: content: e.currentTarget.value}
        Session.set "target" + t.data._id, false
  
    # delete
    "click #delete": (e, t) ->
      post = Posts.findOne(t.data)
      Posts.remove _id: post._id
 
if Meteor.isServer
  # publish posts to client
  Meteor.publish "posts", ->
    Posts.find()
