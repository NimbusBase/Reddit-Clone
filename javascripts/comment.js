
var slideDownInitHeight = new Array();
	var slidedown_direction = new Array();
	var slidedownActive = false;
	var mrcHeight = false;
	var slidedownSpeed = 3; 	// Higher value = faster script
	var slidedownTimer = 7;	// Lower value = faster script
	function slidedown_showHide(boxId)
	{
		if(!slidedown_direction[boxId])slidedown_direction[boxId] = 1;
		if(!slideDownInitHeight[boxId])slideDownInitHeight[boxId] = 0;
		
		if(slideDownInitHeight[boxId]==0)slidedown_direction[boxId]=slidedownSpeed; else slidedown_direction[boxId] = slidedownSpeed*-1;
		
		slidedownContentBox = document.getElementById(boxId);
		var subDivs = slidedownContentBox.getElementsByTagName('DIV');
		for(var no=0;no<subDivs.length;no++){
			if(subDivs[no].className=='dhtmlgoodies_mrc')slidedownContent = subDivs[no];	
		}

		mrcHeight = slidedownContent.offsetHeight;
	
		slidedownContentBox.style.visibility='visible';
		slidedownActive = true;
		slidedown_showHide_start(slidedownContentBox,slidedownContent);
	}
	function slidedown_showHide_start(slidedownContentBox,slidedownContent)
	{

		if(!slidedownActive)return;
		slideDownInitHeight[slidedownContentBox.id] = slideDownInitHeight[slidedownContentBox.id]/1 + slidedown_direction[slidedownContentBox.id];
		if(slideDownInitHeight[slidedownContentBox.id] <= 0){
			slidedownActive = false;	
			slidedownContentBox.style.visibility='hidden';
			slideDownInitHeight[slidedownContentBox.id] = 0;
		}
		if(slideDownInitHeight[slidedownContentBox.id]>mrcHeight){
			slidedownActive = false;	
		}
		slidedownContentBox.style.height = slideDownInitHeight[slidedownContentBox.id] + 'px';
		slidedownContent.style.top = slideDownInitHeight[slidedownContentBox.id] - mrcHeight + 'px';

		setTimeout('slidedown_showHide_start(document.getElementById("' + slidedownContentBox.id + '"),document.getElementById("' + slidedownContent.id + '"))',slidedownTimer);
	}
	
	function setSlideDownSpeed(newSpeed)
	{
		slidedownSpeed = newSpeed;
		
	}
