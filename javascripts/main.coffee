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
window.UpVote =  Nimbus.Model.setup("UpVote", ["postid", "voter"])
window.DownVote =  Nimbus.Model.setup("DownVote", ["postid", "voter"])

window.Post.ordersort = (a,b)->
	x = Date(a.create_time);
	y = Date(b.create_time);
	if( x < y)
		return -1
	else
		return 1


# angular  code
#############
window.Redditate=angular.module("Redditate",[])
.controller("RedditateControl", ($scope)->
	 
	$scope.login = "login" 
	$scope.loginOut = ()->
		if Nimbus.Auth.authorized()
			Nimbus.Auth.logout()
			$scope.loadData()
		else 
			Nimbus.Auth.authorize("GCloud")
			$scope.loadData()


			 
	$scope.loadData = ()->
		$scope.post_data = window.Post.all().sort(window.Post.ordersort)

		for i in $scope.post_data
			if(i.owner ==  localStorage["user_email"])
				i.canDelete = true
			else
				i.canDelete = false 
			# alert(i.canDelete) 
			i.comments = window.Comment.findAllByAttribute("postid",i.id)

	$scope.loadData()

	$scope.bootPostAdd = ()->
		bootbox.prompt("Add new post", (result)->
			if result is null
				return 
			if ((result.title is null)  or  (result.link is null))
				alert("should not be  null")
			else
				window.addPost(result.title, result.link))
		$scope.loadData()

	$scope.bootPostDelete = (id)->
		bootbox.confirm("Are you sure?", (result)->
			if(result is true) 
				p = window.Post.find(id)
				p.destroy()
			return 
		)
	$scope.bootPostEdit = (id)->
		bootbox.prompt("Edit  post",(result)->
			if result is null
				return 
			if ((result.title is null)  or  (result.link is null))
				alert("should not be  null")
			else
				EditPost(id,result.title, result.link)
		)










	$scope.ta = ()->
		alert("hahaha")

)




# window.RedditateControl2 = ($scope)-> 
# 	$scope.login = "321"
# 	$scope.hi = ()->
# 		alert "hi"
# 	return  $scope





#############
 

#Sync  
Nimbus.Auth.set_app_ready(()->  

   	
	if Nimbus.Auth.authorized?  && Nimbus.Auth.authorized()
		localStorage["user_email"] = window.user_email
		$("#loginfo").html("Logout")

		window.Post.sync_all ()->
			window.Comment.sync_all()
		 
	else if not (localStorage["state"] is "Auth")
	 	
		localStorage["Post_count"] = window.Post.all().length 
		localStorage["Comment_count"]  =  window.Comment.all().length
		window.Post.sync_all  ()->
			window.Comment.sync_all ()->
				# if  localStorage["Post_count"] <  window.Post.all().length 
				# 	setTimeout("window.location.reload();",3000)
				# if   localStorage["Comment_count"] <  window.Comment.all().length
				#     setTimeout("window.location.reload();",3000)

	
	angular.bootstrap(document.body, ['Redditate']);
)

window.Login_out = ()->
 
	if Nimbus.Auth.authorized?  && Nimbus.Auth.authorized()
		Nimbus.Auth.logout()
		return window.location.reload()
	else
	 

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
	$("#add_comment_" + postid ).val("")
	newcomment =
		"postid":postid
		"comment":comment 
		"owner":window.user_email
		"name" :window.user_name
	window.Comment.create(newcomment)


window.addUpVote = (postid)-> 
	newUpVote =
		"postid":postid 
		"voter":window.user_email 
	window.UpVote.create(newUpVote)

 

window.addDownVote = (postid)-> 
	newDownVote =
		"postid":postid 
		"voter":window.user_email 
	window.DownVote.create(newDownVote)


