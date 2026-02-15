local Frame = require("../../../Lib/UI/Components/Frame")
local TextBox = require("../../../Lib/UI/Components/TextBox")
local TextButton = require("../../../Lib/UI/Components/TextButton")
local Prompt = require("../../../Lib/UI/Prompt")
local Examples = require("../../Core/Examples")
local LoadExample = require("../../Core/LoadExample")
local Key = require("../../Key")
local Navigation = require("../Navigation")
local PromptKey = require("../PromptKey")
local Widget = require("./..")
local ExamplesPage = require("./ExamplesPage")
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
			LoadExample.API(Examples.API)
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
	Navigation.SetPage(ExamplesPage)
end)

local function goToPublishPage(mode: typeof(PublishPage.Mode)?): ()
	if not Key.Get() then
		return PromptKey(Widget.Widget)
	end

	if mode then
		PublishPage.Mode = mode
	end

	PublishPage.Refresh()
	Navigation.SetPage(PublishPage.Page)
end

local myAssetsButton = TextButton({
	Text = "My Assets",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage
})

myAssetsButton.Activated:Connect(function()
	goToPublishPage()
end)

TextButton({
	Text = "Publish Map",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
}).Activated:Connect(function()
	goToPublishPage("Map")
end)

TextButton({
	Text = "Publish Gamemode",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
}).Activated:Connect(function()
	goToPublishPage("Gamemode")
end)

TextButton({
	Text = "Publish Boss",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
}).Activated:Connect(function()
	goToPublishPage("Boss")
end)

TextButton({
	Text = "Enter Key",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
}).Activated:Connect(function()
	PromptKey(Widget.Widget)
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