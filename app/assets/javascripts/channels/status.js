App.status = App.cable.subscriptions.create('StatusChannel', {  
  received: function(data){
  	if(data.online === true){
  		$(".users-"+data.id+"-offline").addClass("hidden");
  		$(".users-"+data.id+"-online").removeClass("hidden");
  	}
  	else{
  		$(".users-"+data.id+"-online").addClass("hidden");
  		$(".users-"+data.id+"-offline").removeClass("hidden");	
  	}
  }
});