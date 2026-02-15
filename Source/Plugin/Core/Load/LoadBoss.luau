local Message = require("../../../Lib/Message")
local Waypoint = require("../../../Lib/Waypoint")

local function LoadBoss(gamemode: Instance): ()
	Waypoint("LoadBoss", function()
		gamemode.Parent = workspace

		Message("Boss has been loaded! You may find it in Workspace.", "success")
	end)
end

return LoadBoss