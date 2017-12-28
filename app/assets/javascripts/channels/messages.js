App.messages = App.cable.subscriptions.create('MessagesChannel', {  
  received: function(data) {
  	$("#room-"+data.id).html("");
    return $("#room-"+data.id).html(data.message);
  }
});