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
window.Post =  Nimbus.Model.setup("Post", ["title", "link", "category"])

#Sync  
Nimbus.Auth.set_app_ready(()->
	if Nimbus.Auth.authorized
		 
		Post.sync_all()
 
	else
	##	Nimbus.Auth.authorize("GCloud")
)

window.addPost = (title,category,link)->
	post =
		"title":title
		"category":category
		"link":link
	window.Post.create(post)

 