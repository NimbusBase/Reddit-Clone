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
window.folder = {"Post":"Post","Comment":"Comment","UpVote":"UpVote","DownVote":"DownVote"}










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
	$scope.login = "Login"
	$scope.newComment=""
  
	$scope.loginOut = ()->
		if Nimbus.Auth.authorized()
			Nimbus.Auth.logout() 
			$scope.loadData()
		else 
			Nimbus.Auth.authorize("GCloud")
			$scope.loadData()


			 
	$scope.loadData = ()->
		if(Nimbus.Auth.authorized())
			$scope.login="Logout"
		else
			$scope.login="Login"
		 

		$scope.post_data = window.Post.all().sort(window.Post.ordersort)
 
		for i in $scope.post_data
			upVotes = window.UpVote.findAllByAttribute('postid',i.id);
			downVotes = window.DownVote.findAllByAttribute('postid',i.id);
			i.upVoteCount = upVotes.length
			i.downVoteCount = downVotes.length

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
				$scope.loadData()
		    
		)
	$scope.bootPostEdit = (id)->
		bootbox.prompt("Edit  post",(result)->
			if result is null
				return 
			if ((result.title is null)  or  (result.link is null))
				alert("should not be  null")
			else
				EditPost(id,result.title, result.link)
			$scope.loadData()
		,id)
		return

	$scope.addComment = (postid)->
		
    	window.addComment(postid,$scope.newComment)
    	$scope.newComment=""
    	$scope.loadData()

    $scope.addUpVote = (postid)->
    	if not Nimbus.Auth.authorized()
    		return  alert("you should login before this action !")
    	votes = window.UpVote.findAllByAttribute('postid',postid)
    	for i in  votes 
    		if i.voter is window.user_email
    			return  alert("you have voted~!")

    	window.addUpVote(postid)

    $scope.addDownVote = (postid)->
    	if not Nimbus.Auth.authorized()
    		return  alert("you should login before this action !")
    	votes = window.DownVote.findAllByAttribute('postid',postid)
    	for i in  votes 
    		if i.voter is window.user_email
    			return  alert("you have voted~!")
    	window.addDownVote(postid)

    $scope.showComment = (id)->
    	className = $('#comment_'+id).attr('class')
    	if(className is "foldout")
    		$('#comment_'+id).attr('class', "foldout2")
    	else
    		$('#comment_'+id).attr('class', "foldout")


    
	$scope.ta = ()->
		alert("hahaha")
)




# window.RedditateControl2 = ($scope)-> 
# 	$scope.login = "321"
# 	$scope.hi = ()->
# 		alert "hi"
# 	return  $scope





#############
window.syncData = ()->
	window.Post.sync_all  ()->
		window.Comment.sync_all ()->
			window.UpVote.sync_all ()->
				window.DownVote.sync_all ()->
					window.loadData()

window.loadData = ()->
	angular.element('[ng-controller=RedditateControl]').scope().loadData()
	angular.element('[ng-controller=RedditateControl]').scope().$apply()
	 

#Sync  
Nimbus.Auth.set_app_ready(()->  

   
	if Nimbus.Auth.authorized?  && Nimbus.Auth.authorized()
		localStorage["user_email"] = window.user_email
		#$("#loginfo").html("Logout")

		 
	else if not (localStorage["state"] is "Auth")
	 	
		localStorage["Post_count"] = window.Post.all().length 
		localStorage["Comment_count"]  =  window.Comment.all().length

	window.syncData()
	angular.bootstrap(document.body, ['Redditate'])
	
	setInterval("window.syncData();",5000)
	setInterval("window.loadData();",1000)
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
	window.loadData()

window.EditPost = (id,title,link)->
	p = Post.find(id)
	p.title = title
	p.link = link
	p.save()
	window.loadData()




window.addComment = (postid,comment)->
	comment = comment
	newcomment =
		"postid":postid
		"comment":comment 
		"owner":window.user_email
		"name" :window.user_name
	window.Comment.create(newcomment)
	window.loadData()


window.addUpVote = (postid)-> 
	newUpVote =
		"postid":postid 
		"voter":window.user_email 
	window.UpVote.create(newUpVote)
	window.loadData()

 

window.addDownVote = (postid)-> 
	newDownVote =
		"postid":postid 
		"voter":window.user_email 
	window.DownVote.create(newDownVote)
	window.loadData()


