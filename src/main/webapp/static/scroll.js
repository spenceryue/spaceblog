var scroller,
	dT = 16.67,
	error = 15,
	fixed = 20,
	scrollComplete;

function scrollerClicked(event) {
	var i = parseInt(event.target.id);
	list.scrollTop = scrollModulus*i*delta;
	console.log('scrollTop (raw): ' + list.scrollTop);
	deactivateLast(last);
	updateFocus(i);
}

function resizeScroller() {
	// alert(maxHeight + ' ' + height);
	var limit = 0.50 * window.innerHeight - 0.10 * window.innerWidth;
	var half = 0.06*(list.children.length+1)/2 * Math.min(window.innerHeight, window.innerWidth);
	if (half > limit) {
		var offset = 0.10*window.innerWidth - (half - limit);
		if (offset < 0) {
			scroller.style.marginTop = 0;
			scroller.style.marginBottom = 0;
		} else {
			scroller.style.marginTop = offset+'px';
			scroller.style.marginBottom = offset+'px';
		}
	}
	// alert(half + ' '+limit);
	// alert(0.10*window.innerWidth);
	// alert(offset);
}

function initScroll(tries) {
	if (typeof document.getElementById('scroller') == 'undefined'
		|| document.getElementById('scroller') == null
		|| typeof list == 'undefined'
		|| list == null) {
		if (tries < 5)
			setTimeout(function(){initScroll(tries+1)},500);
		else
			console.log('scroller element was not loaded after 5 tries.')
	} else {
		scroller = document.getElementById('scroller');
		var node;
		for (var i=0; i<list.children.length; i++) {
			node = document.createElement('div');
        	node.className = 'node';
			node.onclick = scrollerClicked;
			node.id = i;
			node.innerHTML = (i+1); // gimicky...
			scroller.appendChild(node);
		}
		// Adjust scroller and line height
		var maxHeight = 'calc(100vh - 10vw)';
		var height = 6*(list.children.length+1)+'vmin';
		scroller.style.maxHeight = maxHeight;
		scroller.style.height = height;
		document.styleSheets[1].addRule('nav#scroller::before', 'height: ' + 6*(list.children.length-1) + 'vmin;');
		resizeScroller();
		window.addEventListener('resize',resizeScroller);
		scrollComplete = 1;
		var a = setTimeout(function mySuperDuperClosure2() {
			if (gradientComplete){
				updateFocus(0);
				clearTimeout(a);
			}
			else
				setTimeout(myClosure2, 300);
		}, 300);
	}
}

initScroll(0);