var xlinkns = "http://www.w3.org/1999/xlink",
	lastIndex,
	scale,
	expandComplete;

function liClicked(index) {
	var planet = list.children[index];
	var scrollTo;
	if (planet.classList.contains('active')) {
		console.log('disabling '+index);
		lastIndex = null;
		planet.querySelectorAll('textPath')[0].setAttributeNS(xlinkns, 'xlink:href', '#subject');
		planet.querySelectorAll('textPath')[1].setAttributeNS(xlinkns, 'xlink:href', '#date');	
		if (typeof scrollerComplete != 'undefined')
			deactivateLast(last);
		scrollTo = Math.floor(index/perRow)*scrollModulus;
	} else {
		console.log('enabling ' + index);
		if (lastIndex != null)
			if (lastIndex != index) {
				console.log('cleaning up ' + lastIndex);
				liClicked(lastIndex, list.children[lastIndex]);
			}
		lastIndex = index;
		planet.querySelectorAll('textPath')[0].setAttributeNS(xlinkns, 'xlink:href', '#expandSubject');
		planet.querySelectorAll('textPath')[1].setAttributeNS(xlinkns, 'xlink:href', '#expandDate');
		if (typeof scrollerComplete != 'undefined') {
			deactivateLast(last);
			updateFocus(index);
		}
		if (perRow > 1 && index%perRow)
			scrollTo = (Math.floor(index/perRow)+1)*scrollModulus;
		else
			scrollTo = Math.floor(index/perRow)*scrollModulus;
	}

	list.classList.toggle('active');
	console.log(index);
	console.log(planet.id);
	planet.classList.toggle('active');
	planet.querySelector('svg').classList.toggle('active');
	planet.querySelector('text').classList.toggle('active');
	planet.querySelector('text.date').classList.toggle('active');
	planet.querySelector('.content').classList.toggle('active');
	list.scrollTop = scrollTo;
}

function setExpandScale() {
	scale = 0.80 * window.innerWidth / (0.66 * window.innerHeight);
	document.styleSheets[1].addRule('svg text.active', 'font-size: ' + 12.3/scale + 'px;');
	document.styleSheets[1].addRule('svg text.date.active', 'font-size: ' + 4.6125/scale + 'px;');
	document.styleSheets[1].addRule('svg text.date.active #time', 'font-size: ' + 4.6125/scale + 'px;');
}

function initLiGrow() {
	if (typeof list == 'undefined'
		|| list == null
		|| typeof list.lastChild == 'undefined'
		|| list.lastChild == null
		|| !gradientComplete)
		setTimeout(initLiGrow, 300);
	else {
		for (var i=0; i< list.children.length; i++){
			list.children[i].addEventListener('click',function(ind){return function(e) {liClicked(ind);};}(i));
			console.log(list.children[i].id);
		}
		setExpandScale();
		window.addEventListener('resize',setExpandScale);
		expandComplete = 1;
	}
}

initLiGrow();