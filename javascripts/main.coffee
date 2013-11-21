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
window.Post =  Nimbus.Model.setup("Post", ["title", "link", "category","create_time"])
window.Comment = Nimbus.Model.setup("Comment", ["postid", "comment"])


window.Post.ordersort = (a,b)->
	x = Date(a.create_time);
	y = Date(b.create_time);
	if( x < y)
		return -1
	else
		return 1

#Sync  
Nimbus.Auth.set_app_ready(()->
	if Nimbus.Auth.authorized
		localStorage["user_email"] = window.user_email
		$("#loginfo").html("Logout") ;

		window.Post.sync_all()
		 
	else
	##	Nimbus.Auth.authorize("GCloud")
)

window.Login_out = ()->
 
	if Nimbus.Auth.authorized?  && Nimbus.Auth.authorized()
		Nimbus.Auth.logout()
		return window.location.reload()
	else
	 	Nimbus.Auth.authorize('GCloud');

window.addPost = (title,link)->
	post =
		"title":title
		"category":null
		"link":link
		"create_time":Date()
		"owner":window.user_email
	window.Post.create(post)

window.EditPost = (id,title,link)->
	p = Post.find(id)
	p.title = title
	p.link = link
	p.save()




window.addComment = (postid,comment)->
	newcomment =
		"postid":postid
		"comment":comment 
		"owner":window.user_email
	window.Comment.create(newcomment)

 