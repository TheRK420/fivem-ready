(function(){

	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="menu">' +
			'<table>' +
				'<thead>' +
					'<tr>' +
						'{{#head}}<td>{{content}}</td>{{/head}}' +
					'</tr>' +
				'</thead>'+
				'<tbody>' +
					'{{#rows}}' +
						'<tr>' +
							'{{#cols}}<td>{{{content}}}</td>{{/cols}}' +
						'</tr>' +
					'{{/rows}}' +
				'</tbody>' +
			'</table>' +
		'</div>'
	;

	window.HHCore_MENU       = {};
	HHCore_MENU.ResourceName = 'hhrp-menu-list';
	HHCore_MENU.opened       = {};
	HHCore_MENU.focus        = [];
	HHCore_MENU.data         = {};

	HHCore_MENU.open = function(namespace, name, data) {

		if (typeof HHCore_MENU.opened[namespace] == 'undefined') {
			HHCore_MENU.opened[namespace] = {};
		}

		if (typeof HHCore_MENU.opened[namespace][name] != 'undefined') {
			HHCore_MENU.close(namespace, name);
		}

		data._namespace = namespace;
		data._name      = name;

		HHCore_MENU.opened[namespace][name] = data;

		HHCore_MENU.focus.push({
			namespace: namespace,
			name     : name
		});
		
		HHCore_MENU.render();
	};

	HHCore_MENU.close = function(namespace, name) {
		delete HHCore_MENU.opened[namespace][name];

		for (let i=0; i<HHCore_MENU.focus.length; i++) {
			if (HHCore_MENU.focus[i].namespace == namespace && HHCore_MENU.focus[i].name == name) {
				HHCore_MENU.focus.splice(i, 1);
				break;
			}
		}

		HHCore_MENU.render();
	};

	HHCore_MENU.render = function() {

		let menuContainer       = document.getElementById('menus');
		let focused             = HHCore_MENU.getFocused();
		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for (let namespace in HHCore_MENU.opened) {
			
			if (typeof HHCore_MENU.data[namespace] == 'undefined') {
				HHCore_MENU.data[namespace] = {};
			}

			for (let name in HHCore_MENU.opened[namespace]) {

				HHCore_MENU.data[namespace][name] = [];

				let menuData = HHCore_MENU.opened[namespace][name];
				let view = {
					_namespace: menuData._namespace,
					_name     : menuData._name,
					head      : [],
					rows      : []
				};

				for (let i=0; i<menuData.head.length; i++) {
					let item = {content: menuData.head[i]};
					view.head.push(item);
				}

				for (let i=0; i<menuData.rows.length; i++) {
					let row  = menuData.rows[i];
					let data = row.data;

					HHCore_MENU.data[namespace][name].push(data);

					view.rows.push({cols: []});

					for (let j=0; j<row.cols.length; j++) {

						let col     = menuData.rows[i].cols[j];
						let regex   = /\{\{(.*?)\|(.*?)\}\}/g;
						let matches = [];
						let match;

						while ((match = regex.exec(col)) != null) {
							matches.push(match);
						}

						for (let k=0; k<matches.length; k++) {
							col = col.replace('{{' + matches[k][1] + '|' + matches[k][2] + '}}', '<button data-id="' + i + '" data-namespace="' + namespace + '" data-name="' + name + '" data-value="' + matches[k][2] +'">' + matches[k][1] + '</button>');
						}

						view.rows[i].cols.push({data: data, content: col});
					}
				}

				let menu = $(Mustache.render(MenuTpl, view));

				menu.find('button[data-namespace][data-name]').click(function() {
					HHCore_MENU.submit($(this).data('namespace'), $(this).data('name'), {
						data : HHCore_MENU.data[$(this).data('namespace')][$(this).data('name')][parseInt($(this).data('id'))],
						value: $(this).data('value')
					});
				});

				menu.hide();

				menuContainer.appendChild(menu[0]);
			}
		}

		if (typeof focused != 'undefined') {
			$('#menu_' + focused.namespace + '_' + focused.name).show();
		}

		$(menuContainer).show();
	};

	HHCore_MENU.submit = function(namespace, name, data){
		$.post('http://' + HHCore_MENU.ResourceName + '/menu_submit', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			data      : data.data,
			value     : data.value
		}));
	};

	HHCore_MENU.cancel = function(namespace, name){
		$.post('http://' + HHCore_MENU.ResourceName + '/menu_cancel', JSON.stringify({
			_namespace: namespace,
			_name     : name
		}));
	};

	HHCore_MENU.getFocused = function(){
		return HHCore_MENU.focus[HHCore_MENU.focus.length - 1];
	};

	window.onData = (data) => {
		switch(data.action){
			case 'openMenu' : {
				HHCore_MENU.open(data.namespace, data.name, data.data);
				break;
			}

			case 'closeMenu' : {
				HHCore_MENU.close(data.namespace, data.name);
				break;
			}
		}
	};

	window.onload = function(e){
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

	document.onkeyup = function(data) {
		if(data.which == 27) {
			let focused = HHCore_MENU.getFocused();
			HHCore_MENU.cancel(focused.namespace, focused.name);
		}
	};

})();