local Frame = require("../../Lib/UI/Components/Frame")
local ImageButton = require("../../Lib/UI/Components/ImageButton")
local TextLabel = require("../../Lib/UI/Components/TextLabel")

local Navigation = {}

Navigation.NavBar = Frame({
	Name = "NavBar",
	Parent = false,
	CornerRadius = false,
	NoStroke = true,
	Transparency = 1,
	AutomaticSize = Enum.AutomaticSize.Y,
})

local title = TextLabel({
	NoStroke = true,
	FontSize = "Title",
	AutomaticSize = Enum.AutomaticSize.Y,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Text = "NavBar",
	Parent = Navigation.NavBar,
})

local controlsFrame = Frame({
	Name = "Controls",
	Parent = Navigation.NavBar,
	IsContainer = true,
	AspectRatio = {
		Ratio = 2,
	},
	AutomaticSize = Enum.AutomaticSize.X,
})

do
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 5)
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.Parent = controlsFrame
end

local lastPage: Frame?
local backButton = ImageButton({
	Image = Content.fromAssetId(80230791232326),
	Parent = controlsFrame,
	Size = UDim2.fromScale(0.5, 1),
	LayoutOrder = 2,
	IsContainer = true,
	Visible = false,

	Style = {
		ImageColor3 = Enum.StudioStyleGuideColor.MainText,
	},
})

local homeButton = ImageButton({
	Image = Content.fromAssetId(18923169473),
	Parent = controlsFrame,
	Size = UDim2.fromScale(0.5, 1),
	AspectRatio = {
		Ratio = 1,
	},
	IsContainer = true,
})

local pageLayout = Instance.new("UIPageLayout")
pageLayout.Circular = true
pageLayout.TweenTime = 0.2
pageLayout.EasingStyle = Enum.EasingStyle.Exponential
pageLayout.EasingDirection = Enum.EasingDirection.In
pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
pageLayout.TouchInputEnabled = false
pageLayout.ScrollWheelInputEnabled = false
pageLayout.GamepadInputEnabled = false

local firstPage: Frame?
function Navigation.SetPage(page: Frame): ()
	if not pageLayout.Parent then
		pageLayout.Parent = page.Parent
	end

	if not firstPage then
		firstPage = page
	end

	title.Text = "<b>" .. page.Name .. "</b>"

	if pageLayout.CurrentPage == page then
		return
	end
	lastPage = pageLayout.CurrentPage :: Frame?

	pageLayout:JumpTo(page)

	backButton.Visible = lastPage ~= nil
end

backButton.Activated:Connect(function()
	assert(lastPage, "No last page")
	Navigation.SetPage(lastPage)
end)

homeButton.Activated:Connect(function()
	assert(firstPage, "No first page")
	Navigation.SetPage(firstPage)
end)

return Navigation