local Frame = require("./Components/Frame")
local TextBox = require("./Components/TextBox")
local TextButton = require("./Components/TextButton")
local TextLabel = require("./Components/TextLabel")

export type Response = "OK" | "Cancel"

-- Button because frames allow clickthrough
local backgroundFrame = TextButton({
	Text = "",
	CornerRadius = UDim.new(0, 0),

	Size = UDim2.fromScale(1, 1),

	ZIndex = 9,

	Transparency = 0.5,

	NoStroke = true,
	Style = false,

	Visible = false,

	Name = "BackgroundFrame",
	Parent = script.Parent,
})

backgroundFrame.AutoButtonColor = false
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

	Padding = 5,

	Name = "PromptFrame",
	Parent = backgroundFrame,
})

do
	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 6)
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

	TextYAlignment = Enum.TextYAlignment.Top,

	Text = "",

	TextSizeConstraints = {
		Max = 24,
	},

	IsContainer = true,
})

do
	local flex = Instance.new("UIFlexItem")
	flex.FlexMode = Enum.UIFlexMode.Fill
	flex.Parent = messageLabel
end

local inputBox = TextBox({
	Transparency = 1,
	AutomaticSize = Enum.AutomaticSize.Y,

	ZIndex = 11,

	LayoutOrder = 3,

	Name = "InputBox",
	Parent = frame,

	Text = "",

	FontSize = "Body",

	Visible = false,
})

do
	local flex = Instance.new("UIFlexItem")
	flex.FlexMode = Enum.UIFlexMode.Grow
	flex.Parent = inputBox
end

local paddingFrame = Frame({
	IsContainer = true,
	Parent = frame,
	Name = "Padding",
	LayoutOrder = 4,
	Size = UDim2.new(),
	ZIndex = 11,
})

do
	local uiFlexItem = Instance.new("UIFlexItem")
	uiFlexItem.FlexMode = Enum.UIFlexMode.Custom
	uiFlexItem.GrowRatio = 1
	uiFlexItem.ShrinkRatio = 1
	uiFlexItem.Parent = paddingFrame
end

local responsesFrame = Frame({
	Padding = {
		Left = UDim.new(0, 4),
		Right = UDim.new(0, 4),
	},

	LayoutOrder = 5,

	ZIndex = 11,

	AutomaticSize = Enum.AutomaticSize.Y,
	IsContainer = true,
	ClipsDescendants = false,

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

	inputBox.Text = ""

	backgroundFrame.Visible = false
	backgroundFrame.Parent = nil
end

local function runAndClose<T, V>(callback: (value: T, value2: V) -> (), value: T, value2: V): (...any) -> ()
	return function(): ()
		reset()
		callback(value, value2)
	end
end

local function Prompt(widget: DockWidgetPluginGui, title: string, message: string, onResponse: (response: Response, input: string?) -> (), okText: string | false?, cancelText: string | false?, requireInput: boolean?): ()
	reset()

	titleLabel.Text = "<b>" .. title .. "</b>"
	messageLabel.Text = "<i>" .. message .. "</i>"

	confirmButton.Visible = true
	if okText then
		confirmButton.Text = okText
	elseif okText == false then
		confirmButton.Visible = false
	end

	cancelButton.Visible = true
	if cancelText then
		cancelButton.Text = cancelText
	elseif cancelText == false then
		cancelButton.Visible = false
	end

	inputBox.Visible = requireInput or false
	paddingFrame.Visible = not inputBox.Visible

	confirmConn = confirmButton.Activated:Connect(function()
		local input = if inputBox.Text ~= "" then inputBox.Text else nil
		runAndClose(onResponse, "OK" :: "OK", input)()
	end)

	cancelConn = cancelButton.Activated:Connect(runAndClose(onResponse, "Cancel" :: "Cancel", nil))

	backgroundFrame.Visible = true
	backgroundFrame.Parent = widget
end

return Prompt