local Selection = game:GetService("Selection")
local Message = require("../../../Lib/Message")
local Waypoint = require("../../../Lib/Waypoint")

local function LoadItems(items: Instance, refer: string): ()
	Waypoint("LoadItems", function()
		local success, err = pcall(function()
			items.Parent = workspace
			return ""
		end)

		if not success then
			Message(err)
		end

		Message(refer .. " have been loaded! You may find them in Workspace.", "success")

		Selection:Set({items})
	end)
end

return LoadItems