Post = new Meteor.Collection("post")
if Meteor.isClient
  Template.posts.post = ->
    Post.find()

  Template.postForm.events "click button": (e, t) ->
    target = t.find("#content")
    Post.insert content: target.value
    target.value = ""
    return

  Template.post.editing = ->
    Session.get "edit-" + @_id

  Template.post.events
    "click #up": (e, t) ->
      Session.set "edit-" + t.data._id, true
      return

    "keypress input": (e, t) ->
      if e.keyCode is 13
        post = Post.findOne(t.data)
        Post.update
          _id: post._id
        ,
          $set:
            content: e.currentTarget.value

        Session.set "edit-" + t.data._id, false
      return

    "click #delete": (e, t) ->
      post = Post.findOne(t.data)
      Post.remove _id: post._id
      return
