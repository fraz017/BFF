App.logs = App.cable.subscriptions.create('LogsChannel', {  
  received: function(data){
  	$(".log-comments").append(data.message);
    $(".box-widget").animate({ scrollTop: $(".box-widget")[0].scrollHeight}, 1000);
  }
});