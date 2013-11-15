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

  window.Post = Nimbus.Model.setup("Post", ["title", "content", "category"]);

  Nimbus.Auth.set_app_ready(function() {
    if (Nimbus.Auth.authorized) {
      return window.Post.sync_all();
    } else {

    }
  });

  window.addPost = function(title, category, content) {
    var post;
    post = {
      "title": title,
      "category": category,
      "content": content
    };
    return window.Post.create(post);
  };

  window.RenderPost = function(callback) {
    return callback(window.Post.all());
  };

}).call(this);
