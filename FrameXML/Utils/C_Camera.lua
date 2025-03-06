local tonumber = tonumber
local type = type
local unpack = unpack

local GetCVar = GetCVar
local GetCVarDefault = GetCVarDefault
local SaveViewRaw = SaveViewRaw
local SetCVar = SetCVar
local SetView = SetView

local CAMERA_STORAGE_INDEX = 7
local CAMERA_RESET_INDEX = 5

_G.SetView = function(viewIndex)
	if type(viewIndex) == "string" then
		viewIndex = tonumber(viewIndex)
	end
	if type(viewIndex) ~= "number" or viewIndex > 5 then
		error("Usage: SetView(viewModeIndex)", 2)
	end
	SetView(viewIndex)
end

C_Camera = {}

C_Camera.Presets = {
	View1 = 1,
	View2 = 2,
	View3 = 3,
	View4 = 4,
	View5 = 5,
	BarberShop = 6,
	BarberShopAlt = 7,
}

local VIEW_ANGLE = {
	[C_Camera.Presets.View1]			= {0, 0.175, 0},
	[C_Camera.Presets.View2]			= {5.55, 0.175, 0},
	[C_Camera.Presets.View3]			= {5.55, 0.350, 0},
	[C_Camera.Presets.View4]			= {13.88, 0.525, 0},
	[C_Camera.Presets.View5]			= {13.88, 0.175, 0},

	[C_Camera.Presets.BarberShop]		= {2.102274, 0, math.pi},
	[C_Camera.Presets.BarberShopAlt]	= {4.204548, 0, math.pi},
}

function C_Camera.CreateView(distance, yaw, pitch)
	if type(distance) ~= "number" then
		error(string.format("bad argument #1 to 'C_Camera.CreateView' (number expected, got %s)", distance ~= nil and type(distance) or "no value"), 2)
	elseif type(yaw) ~= "number" then
		error(string.format("bad argument #2 to 'C_Camera.CreateView' (number expected, got %s)", yaw ~= nil and type(yaw) or "no value"), 2)
	elseif type(pitch) ~= "number" then
		error(string.format("bad argument #3 to 'C_Camera.CreateView' (number expected, got %s)", pitch ~= nil and type(pitch) or "no value"), 2)
	end

	return {distance, yaw, pitch}
end

function C_Camera.SetCameraView(viewID, skipAnimation)
	if type(viewID) ~= "number" then
		error(string.format("bad argument #1 to 'C_Camera.SetCameraView' (number expected, got %s)", viewID ~= nil and type(viewID) or "no value"), 2)
	elseif not VIEW_ANGLE[viewID] then
		error(string.format("bad argument #1 to 'C_Camera.SetCameraView' (unknown view id %s)", viewID), 2)
	end

	local cameraViewBlendStyle = GetCVar("cameraViewBlendStyle")
	local changeBlendStyle = not skipAnimation and tonumber(cameraViewBlendStyle) ~= 1
	local viewIndex = tonumber(GetCVar("cameraView")) or tonumber(GetCVarDefault("cameraView"))

	if changeBlendStyle then
		SetCVar("cameraViewBlendStyle", 1)	-- override blend style
	end

	SaveViewRaw(CAMERA_STORAGE_INDEX, unpack(VIEW_ANGLE[viewID], 1, 3))	-- save desired camera view

	if not skipAnimation and viewIndex == CAMERA_STORAGE_INDEX then
		SetView(CAMERA_RESET_INDEX)		-- change index of current view to prevent animation skipping
	elseif skipAnimation and viewIndex ~= CAMERA_STORAGE_INDEX then
		SetView(CAMERA_STORAGE_INDEX)	-- change index of current view to skip animation, if it differs from CAMERA_STORAGE_INDEX
	end

	SetView(CAMERA_STORAGE_INDEX)

	if changeBlendStyle then
		SetCVar("cameraViewBlendStyle", cameraViewBlendStyle)	-- restore blend style
	end
end