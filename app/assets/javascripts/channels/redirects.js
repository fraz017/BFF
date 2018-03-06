App.redirects = App.cable.subscriptions.create('RedirectsChannel', {  
  received: function(data) {
    $("#accept").attr("href", "/accept/"+data.room_id);
    $("#reject").attr("href", "/reject/"+data.room_id);
    $("#startChat").modal("show");
  }
});