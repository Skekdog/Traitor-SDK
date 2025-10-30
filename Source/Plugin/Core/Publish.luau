local GetPlugin = require("../../Lib/GetPlugin")
local Message = require("../../Lib/Message")

local function Publish(): ()
	GetPlugin:SaveSelectedToRoblox()
	Message("You will need to distribute the asset on the creator store before loading it in-game.", "warn")
end

return Publish