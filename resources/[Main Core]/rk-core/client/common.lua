AddEventHandler('rk:getSharedObject', function(cb)
	cb(RKCore)
end)

function getSharedObject()
	return RKCore
end
