local BaseText = require("../BaseText")

local function TextLabel(params: BaseText.BaseTextParams): TextBox
	local box = Instance.new("TextBox")
	BaseText(box, params)
	return box
end

return TextLabel