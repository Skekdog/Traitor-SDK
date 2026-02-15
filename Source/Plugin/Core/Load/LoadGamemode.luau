local Message = require("../../../Lib/Message")
local Waypoint = require("../../../Lib/Waypoint")

local function LoadGamemode(gamemode: Instance): ()
	Waypoint("LoadGamemode", function()
		gamemode.Parent = workspace

		Message("Gamemode has been loaded! You may find it in Workspace.", "success")
	end)
end

return LoadGamemode