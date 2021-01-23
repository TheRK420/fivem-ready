(function(){

	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="menu{{#align}} align-{{align}}{{/align}}">' +
			'<div class="head"><span>{{{title}}}</span></div>' +
				'<div class="menu-items">' + 
					'{{#elements}}' +
						'<div class="menu-item {{#selected}}selected{{/selected}}">' +
							'{{{label}}}{{#isSlider}} : &lt;{{{sliderLabel}}}&gt;{{/isSlider}}' +
						'</div>' +
					'{{/elements}}' +
				'</div>'+
			'</div>' +
		'</div>'
	;

	window.RKCore_MENU       = {};
	RKCore_MENU.ResourceName = 'RKCore_menu_default';
	RKCore_MENU.opened       = {};
	RKCore_MENU.focus        = [];
	RKCore_MENU.pos          = {};

	RKCore_MENU.open = function(namespace, name, data) {

		if (typeof RKCore_MENU.opened[namespace] == 'undefined') {
			RKCore_MENU.opened[namespace] = {};
		}

		if (typeof RKCore_MENU.opened[namespace][name] != 'undefined') {
			RKCore_MENU.close(namespace, name);
		}

		if (typeof RKCore_MENU.pos[namespace] == 'undefined') {
			RKCore_MENU.pos[namespace] = {};
		}

		for (let i=0; i<data.elements.length; i++) {
			if (typeof data.elements[i].type == 'undefined') {
				data.elements[i].type = 'default';
			}
		}

		data._index     = RKCore_MENU.focus.length;
		data._namespace = namespace;
		data._name      = name;

		for (let i=0; i<data.elements.length; i++) {
			data.elements[i]._namespace = namespace;
			data.elements[i]._name      = name;
		}

		RKCore_MENU.opened[namespace][name] = data;
		RKCore_MENU.pos   [namespace][name] = 0;

		for (let i=0; i<data.elements.length; i++) {
			if (data.elements[i].selected) {
				RKCore_MENU.pos[namespace][name] = i;
			} else {
				data.elements[i].selected = false;
			}
		}

		RKCore_MENU.focus.push({
			namespace: namespace,
			name     : name
		});
		
		RKCore_MENU.render();
		$('#menu_' + namespace + '_' + name).find('.menu-item.selected')[0].scrollIntoView();
	};

	RKCore_MENU.close = function(namespace, name) {
		
		delete RKCore_MENU.opened[namespace][name];

		for (let i=0; i<RKCore_MENU.focus.length; i++) {
			if (RKCore_MENU.focus[i].namespace == namespace && RKCore_MENU.focus[i].name == name) {
				RKCore_MENU.focus.splice(i, 1);
				break;
			}
		}

		RKCore_MENU.render();

	};

	RKCore_MENU.render = function() {

		let menuContainer       = document.getElementById('menus');
		let focused             = RKCore_MENU.getFocused();
		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for (let namespace in RKCore_MENU.opened) {
			for (let name in RKCore_MENU.opened[namespace]) {

				let menuData = RKCore_MENU.opened[namespace][name];
				let view     = JSON.parse(JSON.stringify(menuData));

				for (let i=0; i<menuData.elements.length; i++) {
					let element = view.elements[i];

					switch (element.type) {
						case 'default' : break;

						case 'slider' : {
							element.isSlider    = true;
							element.sliderLabel = (typeof element.options == 'undefined') ? element.value : element.options[element.value];

							break;
						}

						default : break;
					}

					if (i == RKCore_MENU.pos[namespace][name]) {
						element.selected = true;
					}
				}

				let menu = $(Mustache.render(MenuTpl, view))[0];
				$(menu).hide();
				menuContainer.appendChild(menu);
			}
		}

		if (typeof focused != 'undefined') {
			$('#menu_' + focused.namespace + '_' + focused.name).show();
		}

		$(menuContainer).show();

	};

	RKCore_MENU.submit = function(namespace, name, data) {
		$.post('http://' + RKCore_MENU.ResourceName + '/menu_submit', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : RKCore_MENU.opened[namespace][name].elements
		}));
	};

	RKCore_MENU.cancel = function(namespace, name) {
		$.post('http://' + RKCore_MENU.ResourceName + '/menu_cancel', JSON.stringify({
			_namespace: namespace,
			_name     : name
		}));
	};

	RKCore_MENU.change = function(namespace, name, data) {
		$.post('http://' + RKCore_MENU.ResourceName + '/menu_change', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : RKCore_MENU.opened[namespace][name].elements
		}));
	};

	RKCore_MENU.getFocused = function() {
		return RKCore_MENU.focus[RKCore_MENU.focus.length - 1];
	};

	window.onData = (data) => {

		switch (data.action) {

			case 'openMenu': {
				RKCore_MENU.open(data.namespace, data.name, data.data);
				break;
			}

			case 'closeMenu': {
				RKCore_MENU.close(data.namespace, data.name);
				break;
			}

			case 'controlPressed': {

				switch (data.control) {

					case 'ENTER': {
						let focused = RKCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu    = RKCore_MENU.opened[focused.namespace][focused.name];
							let pos     = RKCore_MENU.pos[focused.namespace][focused.name];
							let elem    = menu.elements[pos];

							if (menu.elements.length > 0) {
								RKCore_MENU.submit(focused.namespace, focused.name, elem);
							}
						}

						break;
					}

					case 'BACKSPACE': {
						let focused = RKCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							RKCore_MENU.cancel(focused.namespace, focused.name);
						}

						break;
					}

					case 'TOP': {

						let focused = RKCore_MENU.getFocused();

						if (typeof focused != 'undefined') {

							let menu = RKCore_MENU.opened[focused.namespace][focused.name];
							let pos  = RKCore_MENU.pos[focused.namespace][focused.name];

							if (pos > 0) {
								RKCore_MENU.pos[focused.namespace][focused.name]--;
							} else {
								RKCore_MENU.pos[focused.namespace][focused.name] = menu.elements.length - 1;
							}

							let elem = menu.elements[RKCore_MENU.pos[focused.namespace][focused.name]];

							for (let i=0; i<menu.elements.length; i++) {
								if (i == RKCore_MENU.pos[focused.namespace][focused.name]) {
									menu.elements[i].selected = true;
								} else {
									menu.elements[i].selected = false;
								}
							}

							RKCore_MENU.change(focused.namespace, focused.name, elem);
							RKCore_MENU.render();

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;

					}

					case 'DOWN' : {

						let focused = RKCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu   = RKCore_MENU.opened[focused.namespace][focused.name];
							let pos    = RKCore_MENU.pos[focused.namespace][focused.name];
							let length = menu.elements.length;

							if (pos < length - 1) {
								RKCore_MENU.pos[focused.namespace][focused.name]++;
							} else {
								RKCore_MENU.pos[focused.namespace][focused.name] = 0;
							}

							let elem = menu.elements[RKCore_MENU.pos[focused.namespace][focused.name]];

							for (let i=0; i<menu.elements.length; i++) {
								if (i == RKCore_MENU.pos[focused.namespace][focused.name]) {
									menu.elements[i].selected = true;
								} else {
									menu.elements[i].selected = false;
								}
							}

							RKCore_MENU.change(focused.namespace, focused.name, elem);
							RKCore_MENU.render();

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					case 'LEFT' : {

						let focused = RKCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = RKCore_MENU.opened[focused.namespace][focused.name];
							let pos  = RKCore_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									let min = (typeof elem.min == 'undefined') ? 0 : elem.min;

									if (elem.value > min) {
										elem.value--;
										RKCore_MENU.change(focused.namespace, focused.name, elem);
									}

									RKCore_MENU.render();
									break;
								}

								default: break;
							}

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					case 'RIGHT' : {

						let focused = RKCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = RKCore_MENU.opened[focused.namespace][focused.name];
							let pos  = RKCore_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									if (typeof elem.options != 'undefined' && elem.value < elem.options.length - 1) {
										elem.value++;
										RKCore_MENU.change(focused.namespace, focused.name, elem);
									}

									if (typeof elem.max != 'undefined' && elem.value < elem.max) {
										elem.value++;
										RKCore_MENU.change(focused.namespace, focused.name, elem);
									}

									RKCore_MENU.render();
									break;
								}

								default: break;
							}

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					default : break;

				}

				break;
			}

		}

	};

	window.onload = function(e){
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();