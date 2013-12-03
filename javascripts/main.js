// Generated by CoffeeScript 1.6.3
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

  Nimbus.Auth.service = "GCloud";

  localStorage["app_name"] = "waiter-code-sample-bucket";

  window.folder = {
    "Post": "Post",
    "Comment": "Comment"
  };

  window.Post = Nimbus.Model.setup("Post", ["title", "link", "category", "create_time"]);

  window.Comment = Nimbus.Model.setup("Comment", ["postid", "comment", "name"]);

  window.UpVote = Nimbus.Model.setup("UpVote", ["postid", "voter"]);

  window.DownVote = Nimbus.Model.setup("DownVote", ["postid", "voter"]);

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

  window.Redditate = angular.module("Redditate", []).controller("RedditateControl", function($scope) {
    $scope.login = "login";
    $scope.loginOut = function() {
      if (Nimbus.Auth.authorized()) {
        Nimbus.Auth.logout();
        return $scope.loadData();
      } else {
        Nimbus.Auth.authorize("GCloud");
        return $scope.loadData();
      }
    };
    $scope.loadData = function() {
      var i, _i, _len, _ref, _results;
      $scope.post_data = window.Post.all().sort(window.Post.ordersort);
      _ref = $scope.post_data;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        if (i.owner === localStorage["user_email"]) {
          i.canDelete = true;
        } else {
          i.canDelete = false;
        }
        _results.push(i.comments = window.Comment.findAllByAttribute("postid", i.id));
      }
      return _results;
    };
    $scope.loadData();
    $scope.bootPostAdd = function() {
      bootbox.prompt("Add new post", function(result) {
        if (result === null) {
          return;
        }
        if ((result.title === null) || (result.link === null)) {
          return alert("should not be  null");
        } else {
          return window.addPost(result.title, result.link);
        }
      });
      return $scope.loadData();
    };
    $scope.bootPostDelete = function(id) {
      return bootbox.confirm("Are you sure?", function(result) {
        var p;
        if (result === true) {
          p = window.Post.find(id);
          p.destroy();
        }
      });
    };
    $scope.bootPostEdit = function(id) {
      return bootbox.prompt("Edit  post", function(result) {
        if (result === null) {
          return;
        }
        if ((result.title === null) || (result.link === null)) {
          return alert("should not be  null");
        } else {
          return EditPost(id, result.title, result.link);
        }
      });
    };
    $scope.showComment = function(id) {
      var className;
      className = $('#comment_' + id).attr('class');
      if (className === "foldout") {
        $('#comment_' + id).attr('class', "foldout2");
      } else {
        $('#comment_' + id).attr('class', "foldout");
      }
      $scope.newComment = "";
      return $scope.addComment = function(postid) {
        window.addComment(postid, $scope.newComment);
        return $scope.newComment = "";
      };
    };
    return $scope.ta = function() {
      return alert("hahaha");
    };
  });

  Nimbus.Auth.set_app_ready(function() {
    if ((Nimbus.Auth.authorized != null) && Nimbus.Auth.authorized()) {
      localStorage["user_email"] = window.user_email;
      $("#loginfo").html("Logout");
      window.Post.sync_all(function() {
        return window.Comment.sync_all();
      });
    } else if (!(localStorage["state"] === "Auth")) {
      localStorage["Post_count"] = window.Post.all().length;
      localStorage["Comment_count"] = window.Comment.all().length;
      window.Post.sync_all(function() {
        return window.Comment.sync_all(function() {});
      });
    }
    return angular.bootstrap(document.body, ['Redditate']);
  });

  window.Login_out = function() {
    if ((Nimbus.Auth.authorized != null) && Nimbus.Auth.authorized()) {
      Nimbus.Auth.logout();
      return window.location.reload();
    } else {

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

  window.addComment = function(postid, comment) {
    var newcomment;
    comment = comment;
    newcomment = {
      "postid": postid,
      "comment": comment,
      "owner": window.user_email,
      "name": window.user_name
    };
    return window.Comment.create(newcomment);
  };

  window.addUpVote = function(postid) {
    var newUpVote;
    newUpVote = {
      "postid": postid,
      "voter": window.user_email
    };
    return window.UpVote.create(newUpVote);
  };

  window.addDownVote = function(postid) {
    var newDownVote;
    newDownVote = {
      "postid": postid,
      "voter": window.user_email
    };
    return window.DownVote.create(newDownVote);
  };

}).call(this);
