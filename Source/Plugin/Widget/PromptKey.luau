local Message = require("../../Lib/Message")
local Prompt = require("../../Lib/UI/Prompt")
local Key = require("../Key")

local function PromptKey(widget: DockWidgetPluginGui): ()
	Prompt(widget, "Enter Key", "Please enter your key", function(response, input)
		if not input then
			return print("x")
		end

		if not Key.Set(input) then
			Message("Invalid key", "error")
		end
	end, nil, nil, true)
end

return PromptKey