local Frame = require("../../../Lib/UI/Components/Frame")
local TextBox = require("../../../Lib/UI/Components/TextBox")
local TextButton = require("../../../Lib/UI/Components/TextButton")
local Prompt = require("../../../Lib/UI/Prompt")
local LoadReference = require("../../Core/LoadReference")
local Key = require("../../Key")
local Navigation = require("../Navigation")
local PromptKey = require("../PromptKey")
local Widget = require("./..")
local Examples = require("./ExamplesPage")
local PublishPage = require("./PublishPage")

local mainPage = Frame({
	Name = "Traitor! SDK",
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

local loadAPIReferenceButton = TextButton({
	Text = "Load API Reference",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
})

loadAPIReferenceButton.Activated:Connect(function()
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
	if not Key.Get() then
		return PromptKey(Widget.Widget)
	end

	PublishPage.Mode = "Map"
	Navigation.SetPage(PublishPage.Page)
end)

local publishGamemodeButton = TextButton({
	Text = "Publish Gamemode",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
})

publishGamemodeButton.Activated:Connect(function()
	PublishPage.Mode = "Gamemode"
	Navigation.SetPage(PublishPage.Page)
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