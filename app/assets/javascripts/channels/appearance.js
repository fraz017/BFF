App.appearance = App.cable.subscriptions.create('AppearanceChannel', {  
  connected: function(data) {
    // console.log("here");
    // console.log(data)
  },
  disconnected: function(data){
  	// console.log("disconnected");
  }
});