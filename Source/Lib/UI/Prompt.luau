local Frame = require("./Components/Frame")
local TextButton = require("./Components/TextButton")
local TextLabel = require("./Components/TextLabel")

export type Response = "OK" | "Cancel"

local backgroundFrame = Frame({
	CornerRadius = UDim.new(0, 0),

	Size = UDim2.fromScale(1, 1),

	ZIndex = 9,

	Transparency = 0.5,

	NoStroke = true,

	Visible = false,

	Name = "BackgroundFrame",
	Parent = script.Parent,
})

backgroundFrame.BackgroundColor3 = Color3.new(0, 0, 0)

local frame = Frame({
	ZIndex = 10,

	Size = UDim2.fromScale(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),

	Visible = true,

	SizeConstraints = {
		Max = Vector2.new(350, 250),
	},

	Name = "PromptFrame",
	Parent = backgroundFrame,
})

do
	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 4)
	listLayout.Parent = frame
end

local titleLabel = TextLabel({
	Text = "",
	AutomaticSize = Enum.AutomaticSize.Y,
	FontSize = "Title",

	IsContainer = true,

	LayoutOrder = 1,

	ZIndex = 11,

	Name = "TitleLabel",
	Parent = frame,
})

local messageLabel = TextLabel({
	Transparency = 1,
	AutomaticSize = Enum.AutomaticSize.Y,

	ZIndex = 11,

	LayoutOrder = 2,

	Name = "MessageLabel",
	Parent = frame,

	Text = "",

	TextSizeConstraints = {
		Max = 24,
	},

	IsContainer = true,
})

do
	local flex = Instance.new("UIFlexItem")
	flex.FlexMode = Enum.UIFlexMode.Grow
	flex.Parent = messageLabel
end

local responsesFrame = Frame({
	Padding = {
		Left = UDim.new(0, 4),
		Right = UDim.new(0, 4),
	},

	LayoutOrder = 3,

	ZIndex = 11,

	AutomaticSize = Enum.AutomaticSize.Y,
	IsContainer = true,

	Name = "ResponsesFrame",
	Parent = frame,
})

do
	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = responsesFrame
end

local confirmButton = TextButton({
	AutomaticSize = Enum.AutomaticSize.Y,
	Size = UDim2.fromScale(0.5, 0),

	ZIndex = 12,

	FontSize = "LargerButton",

	Name = "ConfirmButton",
	Parent = responsesFrame,

	Style = {
		BackgroundColor3 = Enum.StudioStyleGuideColor.MainButton,
		TextColor3 = Enum.StudioStyleGuideColor.BrightText,
	},

	Text = "OK",
})

local cancelButton = TextButton({
	AutomaticSize = Enum.AutomaticSize.Y,
	Size = UDim2.fromScale(0.5, 0),

	ZIndex = 12,

	FontSize = "LargerButton",

	Name = "CancelButton",
	Parent = responsesFrame,

	Text = "Cancel",
})

local confirmConn: RBXScriptConnection?
local cancelConn: RBXScriptConnection?

local function reset(): ()
	if confirmConn then
		confirmConn:Disconnect()
	end

	if cancelConn then
		cancelConn:Disconnect()
	end

	confirmButton.Text = "OK"
	cancelButton.Text = "Cancel"

	backgroundFrame.Visible = false
	backgroundFrame.Parent = nil
end

local function runAndClose<T>(callback: (value: T) -> (), value: T): (...any) -> ()
	return function(): ()
		reset()
		callback(value)
	end
end

local function Prompt(widget: DockWidgetPluginGui, title: string, message: string, onResponse: (response: Response) -> (), okText: string?, cancelText: string?): ()
	reset()

	titleLabel.Text = "<b>" .. title .. "</b>"
	messageLabel.Text = "<i>" .. message .. "</i>"

	if okText then
		confirmButton.Text = okText
	end

	if cancelText then
		cancelButton.Text = cancelText
	end

	confirmConn = confirmButton.Activated:Connect(runAndClose(onResponse, "OK" :: "OK"))
	cancelConn = cancelButton.Activated:Connect(runAndClose(onResponse, "Cancel" :: "Cancel"))

	backgroundFrame.Visible = true
	backgroundFrame.Parent = widget
end

return Prompt