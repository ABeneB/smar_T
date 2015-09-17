function findMe() {
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) { 
      document.getElementById("info").value = position.coords.latitude +', ' + position.coords.longitude;
    });
  }
}