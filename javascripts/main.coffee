# sync  info
syncInfo =  
  "GCloud":
    "key": '195693500289.apps.googleusercontent.com'
    "scope":'https://www.googleapis.com/auth/devstorage.full_control'
    "app_name": "waiter-code-sample-bucket"
    "api_key":'AIzaSyBVDs0bXkbSuflogzPL_JgMUPgRPXSDcCc'
    "project_id":"195693500289"       
 
Nimbus.Auth.setup(syncInfo)




#setup for  public  read
Nimbus.Auth.service = "GCloud"
localStorage["app_name"] ="waiter-code-sample-bucket"
window.folder = {"Post":"Post","Comment":"Comment"}









#Model
window.Post =  Nimbus.Model.setup("Post", ["title", "link", "category","create_time"])
window.Comment = Nimbus.Model.setup("Comment", ["postid", "comment","name"])

window.Post.ordersort = (a,b)->
	x = Date(a.create_time);
	y = Date(b.create_time);
	if( x < y)
		return -1
	else
		return 1

#Sync  
Nimbus.Auth.set_app_ready(()->
	if Nimbus.Auth.authorized?  && Nimbus.Auth.authorized()
		localStorage["user_email"] = window.user_email
		$("#loginfo").html("Logout") ;

		window.Post.sync_all ()->
			window.Comment.sync_all()
		 
	else 
		# localStorage["Post_count"] = window.Post.all().length 
		# localStorage["Comment_count"]  =  window.Comment.all().length
		# window.Post.sync_all  ()->
		# 	window.Comment.sync_all ()->
		# 		if  localStorage["Post_count"] <  window.Post.all().length 
		# 			window.location.reload();
		# 		if   localStorage["Comment_count"] <  window.Comment.all().length
		# 		    window.location.reload();
				
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




window.addComment = (postid)->
	comment = $("#add_comment_" + postid ).val()
	alert(comment)
	newcomment =
		"postid":postid
		"comment":comment 
		"owner":window.user_email
		"name" :window.user_name
	window.Comment.create(newcomment)

 