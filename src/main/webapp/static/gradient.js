'use strict';

var colors = [
[177,177,190],
[227,181,161],
[236,201,136],
[159,214,225],
[177,177,190],
[227,181,161]
];
var colorLen = colors.length;
var step = 0.1;
var colorIndices = new Array(colorLen - 1).join().split(',').map(function (v, i) {
	return i;
});
var gradientSpeed = 0.01; //transition speed

var getColor = function getColor(color1, color2) {
	var r_step = 1 - step;
	var rgb = color1.map(function (v, i) {
		return ~~(r_step * (255-color1[i]) + step * (255-color2[i]));
	}).join();
	if ($target.classList.contains('active'))
		var alpha = 0.75;
	else
		var alpha = 0.75-0.5*Math.pow($target.parentNode.scrollTop%(scrollModulus*delta),2)/scrollPeak;
	return 'rgba(' + rgb + ',' + alpha + ')';
};

var updateColorIdx = function updateColorIdx() {
	colorIndices.forEach(function (v, i) {
		if (i % 2) {
			colorIndices[i] = ~~(colorIndices[i - 1] + Math.random() * (colorLen - 1) + 1) % colorLen;
		} else {
			colorIndices[i] = colorIndices[(i + 1) % (colorLen - 1)];
		}
	});
};

var Gradient = function Gradient() {
	var colorNow = colorIndices.map(function (v) {
		return colors[v];
	});
	var color1 = getColor(colorNow[0], colorNow[1]);
	var color2 = getColor(colorNow[1], colorNow[2]);
	var color3 = getColor(colorNow[2], colorNow[3]);

	$target.style.background = 'linear-gradient(to right bottom, ' + color1 + ', ' + color3 +')';

	step += gradientSpeed;
	if (step >= 1) {
		step %= 1;
		updateColorIdx();
	}
};

window.requestAnimFrame = function () {
	return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || function (callback) {
		window.setTimeout(callback, 1000 / 60);
	};
}();


// Updates currently focused planet
var lastPosition;
// var Rowper; // cache 1/perRow
var filterScrollEvents = function () {
	var position = (list.scrollTop)/scrollModulus;
	
	// Scrolling down
	if (Math.abs(position - lastPosition) > delta/2) {
		// console.log(position + ', ' + last + ', ' + Math.ceil(perRow*position));
		deactivateLast(last);
		console.log('index: ' + Math.round(position/delta));
		updateFocus(Math.round(position/delta));
		console.log(last);
	}
	// // Scrolling up
	// else if (lastPosition - position > Rowper) {
	// 	// console.log(position + ', ' + last + ', ' + Math.floor(perRow*position));
	// 	deactivateLast(last);
	// 	updateFocus(Math.ceil(perRow*position));
	// }
}

var deactivateLast = function(lst) {
	if (lst >= N)
		return;
	if (lst != last)
		deactivateLast(last);
	scroller.children[lst].classList.remove('active');
		// alert('added "active" when should have removed it!');
	scroller.children[lst].style.background = '';
	// last = lst;
}
var updateFocus = function(index) {
	// Deactivate old scroll node
	if (index >= N)
		return;
	last = index;
	lastPosition = last*delta;
	// Paint new scroller
	$target = scroller.children[index];
	Gradient();
	scroller.children[index].classList.add('active');
		// alert('removed "active" when should have added it!');
	// Focus on new planet
	$target = list.children[index];
	updateColorIdx();
}

var $target, last, list, N, scrollModulus, scrollPeak,
	marginTop, marginBottom, paddingTop, paddingBottom,
	liHeight, nRows, perRow, delta, gradientComplete;
var initGradient = function initGradient() {
	// $target = document.getElementsByTagName('li')[0];
	last = 0;
	list = $target.parentNode;
	N = list.children.length;

	var initScrollVars = function() {
		paddingTop = parseFloat(window.getComputedStyle(list).paddingTop.slice(0,-2),10);
		paddingBottom = parseFloat(window.getComputedStyle(list).paddingBottom.slice(0,-2),10);
		marginTop = parseFloat(window.getComputedStyle($target).marginTop.slice(0,-2),10);
		marginBottom = parseFloat(window.getComputedStyle($target).marginBottom.slice(0,-2),10);
		// assumes border-box sizing
		liHeight = parseFloat(window.getComputedStyle($target).height.slice(0,-2),10);
		// Layout overlaps top-bottom margins of adjacent elements
		// But not for flex
		if (list.style.display.includes('flex')){
			scrollModulus = marginTop + liHeight + marginBottom;
			nRows = (parseFloat(list.scrollHeight,10)-paddingTop-paddingBottom) / scrollModulus;
		}
		else{
			scrollModulus = marginTop + liHeight;
			nRows = (parseFloat(list.scrollHeight,10)-paddingTop-paddingBottom-marginBottom) / scrollModulus;
		}
		perRow = list.children.length / Math.round(nRows);
		delta = (N>1) ? (nRows-1)/(N-1) : 0;
		scrollPeak = scrollModulus*scrollModulus/4;

		if (1) {
			console.log('scrollHeight: ' + list.scrollHeight);
			console.log('li height: ' + liHeight);
			console.log('li marginTop: ' + marginTop);
			console.log('li marginBottom: ' + marginBottom);
			console.log('scrollModulus: ' + scrollModulus);
			console.log('paddingTop: ' + paddingTop);
			console.log('paddingBottom: ' + paddingBottom);
			console.log('nRows (raw): ' + nRows);
			console.log('perRow (raw): ' + perRow);
			console.log('delta: ' + delta);

			if (Math.abs(nRows - Math.round(nRows)) > 0.01)
				// || Math.abs(perRow - Math.round(perRow)) > 0.01)
				console.error('large-deviation between raw and rounded. arithmetic error?');
		}

		nRows = Math.round(nRows);
		perRow = Math.ceil(perRow);
		// Rowper = 1/perRow;
		lastPosition = 0;
	};
	initScrollVars();

	if (N > 1)
		list.addEventListener('scroll', filterScrollEvents);
	window.addEventListener('resize',initScrollVars);
	console.log('Gradient Initialized. $target: ' + $target.id);
	gradientComplete = 1;
}

// loading...
var loadGradient = function loadGradient() {
	if (($target=document.getElementsByTagName('li')[0]) === undefined)
		setTimeout(loadGradient, 300);
	else {
		initGradient();
		animLoop();
	}
}


// play
var animLoop = function animLoop() {
	requestAnimFrame(animLoop);
	Gradient();
}

loadGradient();