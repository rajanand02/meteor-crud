Post = new Meteor.Collection("post")
if Meteor.isClient
  # create
  Template.postForm.events 
    "click button": (e, t) ->
      target = t.find("#content")
      Post.insert content: target.value
      target.value = ""
  
  # Read
  Template.posts.post = ->
    Post.find()
  

  # update
  Template.post.editing = ->
    Session.get "edit-" + @_id
  
  Template.post.events
    "click #up": (e, t) ->
      Session.set "edit-" + t.data._id, true

    "keypress input": (e, t) ->
      if e.keyCode is 13
        post = Post.findOne(t.data)
        Post.update {_id: post._id}, { $set: content: e.currentTarget.value}
        Session.set "edit-" + t.data._id, false
      return
  
    # delete
    "click #delete": (e, t) ->
      post = Post.findOne(t.data)
      Post.remove _id: post._id
