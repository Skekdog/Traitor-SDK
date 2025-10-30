local Selection = game:GetService("Selection")
local Message = require("../../../Lib/Message")
local Frame = require("../../../Lib/UI/Components/Frame")
local TextBox = require("../../../Lib/UI/Components/TextBox")
local TextButton = require("../../../Lib/UI/Components/TextButton")
local Prompt = require("../../../Lib/UI/Prompt")
local Waypoint = require("../../../Lib/Waypoint")
local LoadReference = require("../../Core/LoadReference")
local PrepareExportMap = require("../../Core/PrepareExportMap")
local PrepareSounds = require("../../Core/PrepareSounds")
local Publish = require("../../Core/Publish")
local Navigation = require("../Navigation")
local Widget = require("./..")
local Examples = require("./ExamplesPage")

local mainPage = Frame({
	Name = "Traitor Town 3 SDK",
	LayoutOrder = -1,
	Parent = Widget.Pages,

	Padding = {
		Left = 5,
		Right = 5,
		Top = 5,
		Bottom = 5,
	},

	IsContainer = true,
})

do
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = mainPage
end

local loadReferenceButton = TextButton({
	Text = "Load Reference",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
})

loadReferenceButton.Activated:Connect(function()
	Prompt(Widget.Widget, "Load Template", "This will overwrite the contents of ReplicatedStorage! Are you sure you wish to proceed?", function(response)
		if response == "OK" then
			LoadReference()
		end
	end)
end)

local loadExampleButton = TextButton({
	Text = "Load Example",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
})

loadExampleButton.Activated:Connect(function()
	Navigation.SetPage(Examples)
end)

local publishMapButton = TextButton({
	Text = "Publish Map",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
})

publishMapButton.Activated:Connect(function()
	local selection = Selection:Get()
	if #selection ~= 1 then
		Message("Please select exactly one instance to publish.")
		return
	end

	Waypoint("PublishMap", function()
		local map = selection[1]

		if map.Name == "Map" then
			Message("Ensure map name is correctly set before publishing.")
			return
		end

		PrepareExportMap(map)
		Publish()
	end)
end)

local publishGamemodeButton = TextButton({
	Text = "Publish Gamemode",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
})

publishGamemodeButton.Activated:Connect(function()
	local selection = Selection:Get()
	if #selection ~= 1 then
		Message("Please select exactly one instance to publish.")
		return
	end

	Waypoint("PublishGamemode", function()
		local gamemode = selection[1]
		PrepareSounds(gamemode)
		Publish()
	end)
end)

local docsLink = TextBox({
	Text = "Documentation:\nhttps://devforum.roblox.com/t/-/4026195",
	AutomaticSize = Enum.AutomaticSize.Y,
	TextYAlignment = Enum.TextYAlignment.Top,
	IsContainer = true,
	FontSize = "Body",
	Parent = mainPage,
})

docsLink.ClearTextOnFocus = false
docsLink.TextEditable = false

Navigation.SetPage(mainPage)

return mainPage