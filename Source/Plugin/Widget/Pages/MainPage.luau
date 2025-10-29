local Frame = require("../../../Lib/UI/Components/Frame")
local TextBox = require("../../../Lib/UI/Components/TextBox")
local TextButton = require("../../../Lib/UI/Components/TextButton")
local Prompt = require("../../../Lib/UI/Prompt")
local LoadReference = require("../../Core/LoadReference")
local Navigation = require("../Navigation")
local Widget = require("./..")
local Examples = require("./ExamplesPage")

local mainPage = Frame({
	Name = "Traitor Town 3 SDK",
	LayoutOrder = -1,
	Parent = Widget.Pages,

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