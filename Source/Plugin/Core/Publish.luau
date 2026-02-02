local Selection = game:GetService("Selection")
local GetPlugin = require("../../Lib/GetPlugin")
local Message = require("../../Lib/Message")

local function Publish(instance: Instance): ()
	Selection:Set({instance})
	GetPlugin:SaveSelectedToRoblox()
	Message("You will need to distribute the asset on the creator store before loading it in-game.", "warn")
end

return Publish