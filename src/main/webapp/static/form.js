var email,
	subscribe,
	cancel,
	prompt,
	map,
	signout,
	state = false, // false means hidden
	p,
	formComplete;

function changeForm() {
	subscribe.classList.toggle('hide'); // initially hide is present
	cancel.classList.toggle('hide'); // initially hide is present
	prompt.classList.toggle('maintain');
	prompt.children[0].classList.toggle('maintain');
	map.classList.toggle('hide');
	signout.classList.toggle('hide');
	scroller.classList.toggle('hide');
	if (state){
		email.blur();
		setTimeout(function() {subscribe.classList.toggle('invisible');},300);
	} else
		subscribe.classList.toggle('invisible');
	state = !state;
}

function initForm() {
	if (typeof document.getElementById('shield') == 'undefined'
		|| document.getElementById('shield') == null
		|| typeof document.getElementById('email') == 'undefined'
		|| document.getElementById('email') == null
		|| typeof document.getElementById('subscribe') == 'undefined'
		|| document.getElementById('subscribe') == null
		|| typeof document.getElementById('cancel') == 'undefined'
		|| document.getElementById('cancel') == null
		|| typeof document.getElementById('prompt') == 'undefined'
		|| document.getElementById('prompt') == null
		|| typeof document.getElementById('map') == 'undefined'
		|| document.getElementById('map') == null
		|| typeof document.getElementById('signout') == 'undefined'
		|| document.getElementById('signout') == null
		|| typeof document.getElementById('scroller') == 'undefined'
		|| document.getElementById('scroller') == null)
		setTimeout(initForm,300);
	else {
		// Confirm elements loaded/found
		email = document.getElementById('email')
		subscribe = document.getElementById('subscribe');
		cancel = document.getElementById('cancel');
		prompt = document.getElementById('prompt');
		map = document.getElementById('map');
		signout = document.getElementById('signout');
		scroller = document.getElementById('scroller');
		console.log('email: '+email.id);
		console.log('subscribe: '+subscribe.id);
		console.log('cancel: '+cancel.id);
		console.log('prompt: '+prompt.id);
		console.log('map: '+map.id);
		console.log('signout: '+signout.id);
		console.log('scroller: '+scroller.id);
		// Hide subscribe
		subscribe.classList.add('hide','invisible');
		cancel.classList.add('hide');
		// Disable visibility shield on subscribe
		console.log('shield: ' + document.getElementById('shield').id);
		document.getElementById('shield').id = '_shield';
		console.log('disabled shield: ' + document.getElementById('_shield').id);
		// Set up event responses
		prompt.addEventListener('click', changeForm);
		cancel.addEventListener('click', changeForm);
		email.onfocus = function(){email.placeholder='';};
		p = email.placeholder;
		email.onblur = function() {email.placeholder=p;}
		// Done.
		console.log('Form initialized');
		formComplete = 1;
	}
}

initForm();