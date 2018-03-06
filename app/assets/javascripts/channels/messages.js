App.messages = App.cable.subscriptions.create('MessagesChannel', {  
  received: function(data) {
  	$("#text"+data.id).val("");
    $("#replyModal").modal("hide");
    console.log(data);
    if (data.reply == true){
      return $("#room-"+data.id+ " #new_message"+data.message_id).html(data.message);
    }
    else{      
      var div = '<div id="new_message'+data.message_id+'">'+
                data.message +
                '</div>'
      return $("#room-"+data.id).append(div);
    }

  }
});