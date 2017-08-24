App.logs = App.cable.subscriptions.create('LogsChannel', {  
  received: function(data){
  	if(data.log_type == 'message'){
  		$(".log-comments").append(data.message);
  		$(".log-comments:last-child").find(".panel-title").css("color","green");
  	}
  	else{
  		$("#log_"+data.id).append(data.message);
  		$("#log_"+data.id).parent().find(".panel-title").css("color","green");
  	}	
  }
});

$(document).on("click", ".panel-title", function(){
	$(this).css("color","inherit");
});