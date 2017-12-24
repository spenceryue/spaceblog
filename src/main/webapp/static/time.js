function startTime() {
	var today = new Date();
    var h = today.getHours();
    var m = today.getMinutes();
    var s = today.getSeconds();
    am = (h>=12) ? " pm" : " am";
    h = (h%12) ? (h%12) : 12;
    m = (m < 10) ? "0"+m : m;
    s = (s < 10) ? "0"+s : s;
    
    document.getElementById('time').innerHTML = h+ ":" + m + ":" + s + am;
    var t = setTimeout(startTime, 200);
}

var timeComplete;
function initTime() {
	if (typeof document.getElementById('time') == 'undefined' || document.getElementById('time') == null) {
		setTimeout(initTime,500);
	} else {
		startTime();
        timeComplete = 1;
	}
}

initTime();