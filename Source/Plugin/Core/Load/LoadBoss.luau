local Selection = game:GetService("Selection")
local Message = require("../../../Lib/Message")
local Waypoint = require("../../../Lib/Waypoint")

local function LoadBoss(boss: Instance): ()
	Waypoint("LoadBoss", function()
		boss.Parent = workspace

		Message("Boss has been loaded! You may find it in Workspace.", "success")

		Selection:Set({boss})
	end)
end

return LoadBoss