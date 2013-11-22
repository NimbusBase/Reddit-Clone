// Generated by CoffeeScript 1.4.0
(function() {
  var syncInfo;

  syncInfo = {
    "GCloud": {
      "key": '195693500289.apps.googleusercontent.com',
      "scope": 'https://www.googleapis.com/auth/devstorage.full_control',
      "app_name": "waiter-code-sample-bucket",
      "api_key": 'AIzaSyBVDs0bXkbSuflogzPL_JgMUPgRPXSDcCc',
      "project_id": "195693500289"
    }
  };

  Nimbus.Auth.setup(syncInfo);

  window.Post = Nimbus.Model.setup("Post", ["title", "link", "category", "create_time"]);

  window.Comment = Nimbus.Model.setup("Comment", ["postid", "comment"]);

  window.Post.ordersort = function(a, b) {
    var x, y;
    x = Date(a.create_time);
    y = Date(b.create_time);
    if (x < y) {
      return -1;
    } else {
      return 1;
    }
  };

  Nimbus.Auth.set_app_ready(function() {
    if (Nimbus.Auth.authorized) {
      localStorage["user_email"] = window.user_email;
      $("#loginfo").html("Logout");
      return window.Post.sync_all(function() {
        return window.Comment.sync_all();
      });
    } else {

    }
  });

  window.Login_out = function() {
    if ((Nimbus.Auth.authorized != null) && Nimbus.Auth.authorized()) {
      Nimbus.Auth.logout();
      return window.location.reload();
    } else {
      return Nimbus.Auth.authorize('GCloud');
    }
  };

  window.addPost = function(title, link) {
    var post;
    post = {
      "title": title,
      "category": null,
      "link": link,
      "create_time": Date(),
      "owner": window.user_email
    };
    return window.Post.create(post);
  };

  window.EditPost = function(id, title, link) {
    var p;
    p = Post.find(id);
    p.title = title;
    p.link = link;
    return p.save();
  };

  window.addComment = function(postid) {
    var comment, newcomment;
    comment = $("#add_comment_" + postid).val();
    alert(comment);
    newcomment = {
      "postid": postid,
      "comment": comment,
      "owner": window.user_email
    };
    return window.Comment.create(newcomment);
  };

}).call(this);
