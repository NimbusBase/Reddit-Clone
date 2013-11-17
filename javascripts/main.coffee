# sync  info
syncInfo =  
  "GCloud":
    "key": '195693500289.apps.googleusercontent.com'
    "scope":'https://www.googleapis.com/auth/devstorage.full_control'
    "app_name": "waiter-code-sample-bucket"
    "api_key":'AIzaSyBVDs0bXkbSuflogzPL_JgMUPgRPXSDcCc'
    "project_id":"195693500289"       
 
Nimbus.Auth.setup(syncInfo)
 

#Model
Post =  Nimbus.Model.setup("Post", ["title", "link", "category"])

#Sync  
Nimbus.Auth.set_app_ready(()->
	if Nimbus.Auth.authorized
		 
		Post.sync_all()
		alert(JSON.stringify(Post.all()))
	else
	##	Nimbus.Auth.authorize("GCloud")
)

window.addPost = (title,category,content)->
	post =
		"title":title
		"category":category
		"content":content
	Post.create(post)

window.RenderPost = (callback)-> 
	callback window.Post.all()

exports = this;

exports.Post = Post;