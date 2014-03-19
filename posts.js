Post = new Meteor.Collection("post");
if (Meteor.isClient) {

  Template.posts.post = function () {
    return Post.find();
  };

  Template.postForm.events({
    'click button': function (e,t) {
      var target = t.find("#content");
      Post.insert({content: target.value});
      target.value = ""
    }
  });

  Template.post.editing = function(){
    return Session.get("edit-" + this._id);
  };

  Template.post.events({
    'click #up': function (e,t) {
      Session.set("edit-" + t.data._id, true);
    },
    "keypress input": function (e,t) {
      if(e.keyCode === 13){
        var post = Post.findOne(t.data);
        Post.update({_id: post._id}, {$set: {content: e.currentTarget.value}});
        Session.set("edit-" + t.data._id, false);
      }
    },

    "click #delete": function (e, t) {
      var post = Post.findOne(t.data);
      Post.remove({_id: post._id});
    }
  });

}
