local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Selection = game:GetService("Selection")
local Message = require("../../../Lib/Message")
local Prompt = require("../../../Lib/UI/Prompt")
local Waypoint = require("../../../Lib/Waypoint")
local Widget = require("../../Widget")

local function LoadReference(reference: Instance): ()
	local response: "Cancel" | "OK"?
	Prompt(Widget.Widget, "Warning", "This may overwrite some contents of ReplicatedStorage!", function(res)
		response = res
	end)

	while not response do
		task.wait()
	end

	if response ~= "OK" then
		return
	end

	Waypoint("LoadReference", function()
		local old = ReplicatedStorage:FindFirstChild(reference.Name)
		if old then
			old.Parent = nil
		end

		reference.Parent = ReplicatedStorage

		Message("Reference has been loaded!", "success")

		Selection:Set({reference})
	end)
end

return LoadReference