local SmuggleScripts = require("./Smuggle/SmuggleScripts")
local SmuggleSounds = require("./Smuggle/SmuggleSounds")

local function PrepareExportGamemode(gamemode: Instance): Instance
	gamemode = gamemode:Clone()

	SmuggleSounds(gamemode)
	SmuggleScripts(gamemode)

	gamemode.Parent = workspace
	return gamemode
end

return PrepareExportGamemode