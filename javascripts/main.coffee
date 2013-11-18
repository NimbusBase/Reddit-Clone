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
window.Comment = Nimbus.Model.setup("Comment", ["postid", "comment"])
#Sync  
Nimbus.Auth.set_app_ready(()->
	if Nimbus.Auth.authorized
		localStorage["user_email"] = window.user_email
		Post.sync_all()
		Comment.sync_all()

	else
	##	Nimbus.Auth.authorize("GCloud")
)

window.addPost = (title,link)->
	post =
		"title":title
		"category":null
		"link":link
		"owner":window.user_email
	window.Post.create(post)

window.addComment = (postid,comment)->
	newcomment =
		"postid":postid
		"comment":comment 
		"owner":window.user_email
	window.Comment.create(newcomment)

 