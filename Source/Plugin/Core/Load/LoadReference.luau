local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Message = require("../../../Lib/Message")
local Prompt = require("../../../Lib/UI/Prompt")
local Waypoint = require("../../../Lib/Waypoint")
local Widget = require("../../Widget")

local function LoadReference(reference: Instance): ()
	local response: "Cancel" | "OK"?
	Prompt(Widget.Widget, "Warning", "This will overwrite the contents of ReplicatedStorage!", function(res)
		response = res
	end)

	while not response do
		task.wait()
	end

	if response ~= "OK" then
		return
	end

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