(() => {

	RKCore = {};
	RKCore.HUDElements = [];

	RKCore.setHUDDisplay = function (opacity) {
		$('#hud').css('opacity', opacity);
	};

	RKCore.insertHUDElement = function (name, index, priority, html, data) {
		RKCore.HUDElements.push({
			name: name,
			index: index,
			priority: priority,
			html: html,
			data: data
		});

		RKCore.HUDElements.sort((a, b) => {
			return a.index - b.index || b.priority - a.priority;
		});
	};

	RKCore.updateHUDElement = function (name, data) {

		for (let i = 0; i < RKCore.HUDElements.length; i++) {
			if (RKCore.HUDElements[i].name == name) {
				RKCore.HUDElements[i].data = data;
			}
		}

		RKCore.refreshHUD();
	};

	RKCore.deleteHUDElement = function (name) {
		for (let i = 0; i < RKCore.HUDElements.length; i++) {
			if (RKCore.HUDElements[i].name == name) {
				RKCore.HUDElements.splice(i, 1);
			}
		}

		RKCore.refreshHUD();
	};

	RKCore.refreshHUD = function () {
		$('#hud').html('');

		for (let i = 0; i < RKCore.HUDElements.length; i++) {
			let html = Mustache.render(RKCore.HUDElements[i].html, RKCore.HUDElements[i].data);
			$('#hud').append(html);
		}
	};

	RKCore.inventoryNotification = function (add, item, count) {
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
				RKCore.setHUDDisplay(data.opacity);
				break;
			}

			case 'insertHUDElement': {
				RKCore.insertHUDElement(data.name, data.index, data.priority, data.html, data.data);
				break;
			}

			case 'updateHUDElement': {
				RKCore.updateHUDElement(data.name, data.data);
				break;
			}

			case 'deleteHUDElement': {
				RKCore.deleteHUDElement(data.name);
				break;
			}

			case 'inventoryNotification': {
				RKCore.inventoryNotification(data.add, data.item, data.count);
			}
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();