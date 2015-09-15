function findMe() {
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) { 
      document.getElementById("info").value = position.coords.latitude +', ' + position.coords.longitude;
    }, function() {
      alert('We couldn\'t find your position.');
    });
  } else {
    alert('Your browser doesn\'t support geolocation.');
  }
}