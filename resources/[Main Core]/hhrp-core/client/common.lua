AddEventHandler('hhrp:getSharedObject', function(cb)
	cb(HHCore)
end)

function getSharedObject()
	return HHCore
end
