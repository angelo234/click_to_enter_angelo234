-- This Source Code Form is subject to the terms of the bCDDL, v. 1.1.
-- If a copy of the bCDDL was not distributed with this
-- file, You can obtain one at http://beamng.com/bCDDL-1.1.txt

local M = {}

local raycastFlags = bit.bor(SOTVehicle)

local selectingVehicle = false

local function setUnicycleInactive(unicycle)
  be.nodeGrabber:clearVehicleFixedNodes(unicycle:getID())
  unicycle:setActive(0)
end

local function enterVehicle(veh)
  be:enterVehicle(0, veh)
  selectingVehicle = false
end

-- While the user is holding the middle click down, every frame, send a raycast out until a vehicle is hit
-- Once a vehicle is hit, enter the vehicle and stop raycasting even if middle click is down to prevent entering another vehicle accidentally
-- Only once middle click is lifted will the user be able to begin another raycasting
local function onUpdate(dt)
  if not selectingVehicle then return end

  local raycastInfo = cameraMouseRayCast(true, raycastFlags)
  if not raycastInfo or not raycastInfo.object then return end

  local veh = be:getPlayerVehicle(0)
  if veh then
    -- Don't allow entering vehicle currently in
    if veh:getID() ~= raycastInfo.object:getID() then
      enterVehicle(raycastInfo.object)
      if veh:getJBeamFilename() == "unicycle" then
        setUnicycleInactive(veh)
      end
      core_camera.setByName(0, "orbit", true)
      commands.setGameCamera()
    end
  else
    enterVehicle(raycastInfo.object)
  end
end

-- Called by input actions on input changed
local function selectVehicle(controllerState)
  selectingVehicle = controllerState == 1
end

M.onUpdate = onUpdate
M.selectVehicle = selectVehicle

return M