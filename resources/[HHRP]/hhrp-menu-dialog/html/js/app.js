(function () {

	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="dialog {{#isBig}}big{{/isBig}}">' +
			'{{#isDefault}}<input type="text" name="value" placeholder="{{title}}" id="inputText"/>{{/isDefault}}' +
				'{{#isBig}}<textarea name="value"/>{{/isBig}}' +
				'<button type="button" name="submit">Accept</button>' +
				'<button type="button" name="cancel">Cancel</button>'
			'</div>' +
		'</div>'
	;

	window.HHCore_MENU       = {};
	HHCore_MENU.ResourceName = 'hhrp-menu-dialog';
	HHCore_MENU.opened       = {};
	HHCore_MENU.focus        = [];
	HHCore_MENU.pos          = {};

	HHCore_MENU.open = function (namespace, name, data) {

		if (typeof HHCore_MENU.opened[namespace] == 'undefined') {
			HHCore_MENU.opened[namespace] = {};
		}

		if (typeof HHCore_MENU.opened[namespace][name] != 'undefined') {
			HHCore_MENU.close(namespace, name);
		}

		if (typeof HHCore_MENU.pos[namespace] == 'undefined') {
			HHCore_MENU.pos[namespace] = {};
		}

		if (typeof data.type == 'undefined') {
			data.type = 'default';
		}

		if (typeof data.align == 'undefined') {
			data.align = 'top-left';
		}

		data._index = HHCore_MENU.focus.length;
		data._namespace = namespace;
		data._name = name;

		HHCore_MENU.opened[namespace][name] = data;
		HHCore_MENU.pos[namespace][name] = 0;

		HHCore_MENU.focus.push({
			namespace: namespace,
			name: name
		});

		document.onkeyup = function (key) {
			if (key.which == 27) { // Escape key
				$.post('http://' + HHCore_MENU.ResourceName + '/menu_cancel', JSON.stringify(data));
			} else if (key.which == 13) { // Enter key
				$.post('http://' + HHCore_MENU.ResourceName + '/menu_submit', JSON.stringify(data));
			}
		};

		HHCore_MENU.render();

	};

	HHCore_MENU.close = function (namespace, name) {

		delete HHCore_MENU.opened[namespace][name];

		for (let i = 0; i < HHCore_MENU.focus.length; i++) {
			if (HHCore_MENU.focus[i].namespace == namespace && HHCore_MENU.focus[i].name == name) {
				HHCore_MENU.focus.splice(i, 1);
				break;
			}
		}

		HHCore_MENU.render();

	};

	HHCore_MENU.render = function () {

		let menuContainer = $('#menus')[0];

		$(menuContainer).find('button[name="submit"]').unbind('click');
		$(menuContainer).find('button[name="cancel"]').unbind('click');
		$(menuContainer).find('[name="value"]').unbind('input propertychange');

		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for (let namespace in HHCore_MENU.opened) {
			for (let name in HHCore_MENU.opened[namespace]) {

				let menuData = HHCore_MENU.opened[namespace][name];
				let view = JSON.parse(JSON.stringify(menuData));

				switch (menuData.type) {
					case 'default': {
						view.isDefault = true;
						break;
					}

					case 'big': {
						view.isBig = true;
						break;
					}

					default: break;
				}

				let menu = $(Mustache.render(MenuTpl, view))[0];

				$(menu).css('z-index', 1000 + view._index);

				$(menu).find('button[name="submit"]').click(function () {
					HHCore_MENU.submit(this.namespace, this.name, this.data);
				}.bind({ namespace: namespace, name: name, data: menuData }));

				$(menu).find('button[name="cancel"]').click(function () {
					HHCore_MENU.cancel(this.namespace, this.name, this.data);
				}.bind({ namespace: namespace, name: name, data: menuData }));

				$(menu).find('[name="value"]').bind('input propertychange', function () {
					this.data.value = $(menu).find('[name="value"]').val();
					HHCore_MENU.change(this.namespace, this.name, this.data);
				}.bind({ namespace: namespace, name: name, data: menuData }));

				if (typeof menuData.value != 'undefined')
					$(menu).find('[name="value"]').val(menuData.value);

				menuContainer.appendChild(menu);
			}
		}

		$(menuContainer).show();
		$("#inputText").focus();
	};

	HHCore_MENU.submit = function (namespace, name, data) {
		$.post('http://' + HHCore_MENU.ResourceName + '/menu_submit', JSON.stringify(data));
	};

	HHCore_MENU.cancel = function (namespace, name, data) {
		$.post('http://' + HHCore_MENU.ResourceName + '/menu_cancel', JSON.stringify(data));
	};

	HHCore_MENU.change = function (namespace, name, data) {
		$.post('http://' + HHCore_MENU.ResourceName + '/menu_change', JSON.stringify(data));
	};

	HHCore_MENU.getFocused = function () {
		return HHCore_MENU.focus[HHCore_MENU.focus.length - 1];
	};

	window.onData = (data) => {

		switch (data.action) {
			case 'openMenu': {
				HHCore_MENU.open(data.namespace, data.name, data.data);
				break;
			}

			case 'closeMenu': {
				HHCore_MENU.close(data.namespace, data.name);
				break;
			}
		}

	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();