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
window.Post =  Nimbus.Model.setup("Post", ["title", "content", "category"])

#Sync  
Nimbus.Auth.set_app_ready(()->
	if Nimbus.Auth.authorized
		window.Post.sync_all()
	else
	##	Nimbus.Auth.authorize("GCloud")
)

window.addPost = (title,category,content)->
	post =
		"title":title
		"category":category
		"content":content
	window.Post.create(post)

window.RenderPost = (callback)-> 
	callback window.Post.all()
