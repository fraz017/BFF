App.messages = App.cable.subscriptions.create('MessagesChannel', {  
  received: function(data) {
  	$("#text"+data.id).val("");
    $("#replyModal").modal("hide");
    console.log(data);
    if (data.reply == true){
      return $("#room-"+data.id).html(data.message);
    }
    else{      
      return $("#room-"+data.id).append(data.message);
    }

  }
});