(() => {

	HHCore = {};
	HHCore.HUDElements = [];

	HHCore.setHUDDisplay = function (opacity) {
		$('#hud').css('opacity', opacity);
	};

	HHCore.insertHUDElement = function (name, index, priority, html, data) {
		HHCore.HUDElements.push({
			name: name,
			index: index,
			priority: priority,
			html: html,
			data: data
		});

		HHCore.HUDElements.sort((a, b) => {
			return a.index - b.index || b.priority - a.priority;
		});
	};

	HHCore.updateHUDElement = function (name, data) {

		for (let i = 0; i < HHCore.HUDElements.length; i++) {
			if (HHCore.HUDElements[i].name == name) {
				HHCore.HUDElements[i].data = data;
			}
		}

		HHCore.refreshHUD();
	};

	HHCore.deleteHUDElement = function (name) {
		for (let i = 0; i < HHCore.HUDElements.length; i++) {
			if (HHCore.HUDElements[i].name == name) {
				HHCore.HUDElements.splice(i, 1);
			}
		}

		HHCore.refreshHUD();
	};

	HHCore.refreshHUD = function () {
		$('#hud').html('');

		for (let i = 0; i < HHCore.HUDElements.length; i++) {
			let html = Mustache.render(HHCore.HUDElements[i].html, HHCore.HUDElements[i].data);
			$('#hud').append(html);
		}
	};

	HHCore.inventoryNotification = function (add, item, count) {
		let notif = '';

		if (add) {
			notif += '+';
		} else {
			notif += '-';
		}

		notif += count + ' ' + item.label;

		let elem = $('<div>' + notif + '</div>');

		$('#inventory_notifications').append(elem);

		$(elem).delay(3000).fadeOut(1000, function () {
			elem.remove();
		});
	};

	window.onData = (data) => {
		switch (data.action) {
			case 'setHUDDisplay': {
				HHCore.setHUDDisplay(data.opacity);
				break;
			}

			case 'insertHUDElement': {
				HHCore.insertHUDElement(data.name, data.index, data.priority, data.html, data.data);
				break;
			}

			case 'updateHUDElement': {
				HHCore.updateHUDElement(data.name, data.data);
				break;
			}

			case 'deleteHUDElement': {
				HHCore.deleteHUDElement(data.name);
				break;
			}

			case 'inventoryNotification': {
				HHCore.inventoryNotification(data.add, data.item, data.count);
			}
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();