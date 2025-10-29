local Types = require("../Types")
local BaseGui = require("./BaseGui")

export type TextSizeConstraints = {
	Min: number?,
	Max: number?,
}

local fontSizes = {
	["Title"] = 36,
	["Heading"] = 28,
	["Button"] = 24,
	["LargerButton"] = 32,
	["Body"] = 24,
}

export type FontSize = number | keyof<typeof(fontSizes)>

export type BaseTextParams = Types.Override<BaseGui.BaseGuiParams, {
	Text: string,

	FontSize: FontSize?,
	TextWrapped: boolean?,
	TextTruncate: Enum.TextTruncate?,

	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,

	TextSizeConstraints: TextSizeConstraints?,
}>

local function BaseText<T>(gui: T & (TextLabel | TextButton | TextBox), params: BaseTextParams): ()
	BaseGui(gui, params)

	gui.FontFace = Font.fromEnum(Enum.Font.BuilderSans)
	gui.RichText = true

	if params.FontSize then
		gui.TextSize = if typeof(params.FontSize) == "number" then params.FontSize else fontSizes[params.FontSize]
		if params.TextTruncate ~= nil and params.TextTruncate ~= Enum.TextTruncate.None then
			gui.TextTruncate = params.TextTruncate
		else
			gui.TextWrapped = if params.TextWrapped == nil then true else params.TextWrapped
		end
	else
		gui.TextScaled = true
	end

	if params.TextSizeConstraints then
		local constraints = Instance.new("UITextSizeConstraint")
		constraints.MinTextSize = params.TextSizeConstraints.Min or 0
		constraints.MaxTextSize = params.TextSizeConstraints.Max or math.huge
		constraints.Parent = gui
	end

	gui.TextXAlignment = if params.TextXAlignment then params.TextXAlignment else Enum.TextXAlignment.Center
	gui.TextYAlignment = if params.TextYAlignment then params.TextYAlignment else Enum.TextYAlignment.Center

	gui.Text = params.Text
end

return BaseText