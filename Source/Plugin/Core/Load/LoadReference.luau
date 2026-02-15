local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Message = require("../../../Lib/Message")
local Waypoint = require("../../../Lib/Waypoint")

local function LoadReference(reference: Instance): ()
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