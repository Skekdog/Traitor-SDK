local SmuggleScripts = require("./Smuggle/SmuggleScripts")
local SmuggleSounds = require("./Smuggle/SmuggleSounds")

local function PrepareExportGamemode(gamemode: Instance): Instance
	gamemode = gamemode:Clone()

	gamemode = SmuggleScripts(gamemode)

	SmuggleSounds(gamemode)

	gamemode.Parent = workspace
	return gamemode
end

return PrepareExportGamemode