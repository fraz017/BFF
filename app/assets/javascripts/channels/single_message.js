App.single_messages = App.cable.subscriptions.create('SingleMessagesChannel', {  
  received: function(data) {
    $(".reply-main textarea").val("")
    $("#messages-"+data.room_id).append(data.message);
    if (data.flash != null) {
      toastr.info(data.flash);
    }
    return $(".conversation-container").animate({ scrollTop: $(".conversation-container")[0].scrollHeight}, 1000);
  }
});