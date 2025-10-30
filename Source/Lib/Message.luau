local Widget = require("../Plugin/Widget")
local Prompt = require("./UI/Prompt")

local function Message(message: string, kind: "warn" | "error" | "success"?): ()
	local title: string
	if kind == "warn" then
		title = "Alert"
	elseif kind == "success" then
		title = "Success"
	else
		title = "Error"
	end
	Prompt(Widget.Widget, title, message, function() end, nil, false)
end

return Message