local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FetchAsset = require("../../Lib/FetchAsset")
local Message = require("../../Lib/Message")
local Waypoint = require("../../Lib/Waypoint")

local REFERENCE_ID = 116031459660559

local function LoadReference(): ()
	local reference = FetchAsset(REFERENCE_ID)
	assert(reference, "Invalid reference")

	Waypoint("LoadReference", function()
		for _, child in ReplicatedStorage:GetChildren() do
			child.Parent = nil
		end

		reference.Name = "API"
		reference.Parent = ReplicatedStorage

		Message("Reference has been loaded!", "success")
	end)
end

return LoadReference