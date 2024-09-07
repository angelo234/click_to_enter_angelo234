local M = {}

local function getPlayerUnicycle()
  local veh = be:getPlayerVehicle(0)
  if veh and veh:getJBeamFilename() == "unicycle" then
    return veh
  end
end

local function setUnicycleInactive(unicycle)
  be.nodeGrabber:clearVehicleFixedNodes(unicycle:getID())
  unicycle:setActive(0)
end

local function onVehicleSelected()
	local flags = bit.bor(SOTVehicle)
	
	local raycast_info = cameraMouseRayCast(true, flags)
	
	if raycast_info then
		local veh = be:getPlayerVehicle(0)
		
		if veh:getID() ~= raycast_info.object:getID() then
		
			local unicycle = getPlayerUnicycle()
			be:enterVehicle(0, raycast_info.object)
			if unicycle then
				setUnicycleInactive(unicycle)
			end	
			
			core_camera.setByName(0, "orbit", true)
			commands.setGameCamera()
		end
	end
end

M.onVehicleSelected = onVehicleSelected

return M