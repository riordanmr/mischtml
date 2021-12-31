function incrementalUpdate (speedometer)
{
  var target = speedometer.value () < speedometer.max () ?
      speedometer.max () : speedometer.min ();

  speedometer.animatedUpdate (target, 5000);
}

var tick = 1;
var janusStarted = false;

function SetJanusStarted() {
  janusStarted = true;
}

function randomUpdate (speedometer)
{
  if (janusStarted) {
    // var target = Math.random () * speedometer.max ();
    // var time = Math.random () * 5000;
    var time = 1500;
    var target = 100;
    tick++;
    if (tick <= 4) {
      var node = tick;
      target = node * 20;
      var statusId = "node" + node + "status";
      document.getElementById(statusId).style = "color:limegreen";
      document.getElementById(statusId).innerText = "Running";
    } else {
      // added by MRR 2021-12-31 to vary the speed a bit once we reach the limit.
      //time = 5000;
      target = 100 - 10*Math.random();
    }
    //console.trace("randomUpdate here; time=" + (new Date()).toLocaleTimeString() + " target=" + target + " time=" + time);
    speedometer.animatedUpdate(target, time);
  } else {
    var target = 10 + 5 * Math.random();
    var time = 1500;
    speedometer.animatedUpdate(target, time);
  }
}

function stopAnimation (speedometer)
{
  speedometer.stopAnimation ();
}
