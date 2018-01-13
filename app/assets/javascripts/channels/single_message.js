App.single_messages = App.cable.subscriptions.create('SingleMessagesChannel', {  
  received: function(data) {
    $("#messages"+data.room_id).removeClass('hidden')
    return $('#messages'+data.room_id).append(this.renderMessage(data));
  },
  renderMessage: function(data) {
    return "<b><div class='msg-send'>" + data.user + ": </b>" + data.message + "</div>";
  }
});