local Frame = require("../../../Lib/UI/Components/Frame")
local TextButton = require("../../../Lib/UI/Components/TextButton")
local TextLabel = require("../../../Lib/UI/Components/TextLabel")
local Examples = require("../../Core/Examples")
local LoadExample = require("../../Core/LoadExample")
local Widget = require("./..")

local examples = Frame({
	Name = "Examples",
	Parent = Widget.Pages,
	IsContainer = true,
})

do
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = examples
end

TextLabel({
	Text = "Gamemodes",
	LayoutOrder = 1000,
	FontSize = "Heading",
	IsContainer = true,
	AutomaticSize = Enum.AutomaticSize.Y,
	TextXAlignment = Enum.TextXAlignment.Left,
	Name = "GamemodesLabel",
	Parent = examples,
})

TextLabel({
	Text = "Maps",
	LayoutOrder = 2000,
	FontSize = "Heading",
	IsContainer = true,
	AutomaticSize = Enum.AutomaticSize.Y,
	TextXAlignment = Enum.TextXAlignment.Left,
	Name = "MapsLabel",
	Parent = examples,
})

local i = 0
for map, id in Examples.Maps do
	i += 1
	local button = TextButton({
		Text = map,
		AutomaticSize = Enum.AutomaticSize.Y,
		FontSize = "Button",
		LayoutOrder = 2000 + i,
		TextXAlignment = Enum.TextXAlignment.Left,
		Padding = {
			Left = 20,
		},
		Parent = examples,
	})

	button.Activated:Connect(function()
		LoadExample.Map(id)
	end)
end

i = 0
for gamemode, id in Examples.Gamemodes do
	i += 1
	local button = TextButton({
		Text = gamemode,
		AutomaticSize = Enum.AutomaticSize.Y,
		FontSize = "Button",
		LayoutOrder = 1000 + i,
		TextXAlignment = Enum.TextXAlignment.Left,
		Padding = {
			Left = 20,
		},
		Parent = examples,
	})

	button.Activated:Connect(function()
		LoadExample.Gamemode(id)
	end)
end

i = nil

return examples