local Frame = require("../../../Lib/UI/Components/Frame")
local TextBox = require("../../../Lib/UI/Components/TextBox")
local TextButton = require("../../../Lib/UI/Components/TextButton")
local Prompt = require("../../../Lib/UI/Prompt")
local LoadTemplate = require("../../Core/LoadTemplate")
local Navigation = require("../Navigation")
local Widget = require("./..")
local References = require("./References")

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

local loadTemplateButton = TextButton({
	Text = "Load Template",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
})

loadTemplateButton.Activated:Connect(function()
	Prompt(Widget.Widget, "Load Template", "This will overwrite the contents of ReplicatedStorage! Are you sure you wish to proceed?", function(response)
		if response == "OK" then
			LoadTemplate()
		end
	end)
end)

local loadReferenceButton = TextButton({
	Text = "Load Reference",
	FontSize = "Button",
	AutomaticSize = Enum.AutomaticSize.Y,
	Parent = mainPage,
})

loadReferenceButton.Activated:Connect(function()
	Navigation.SetPage(References)
end)

local docsLink = TextBox({
	Text = "Documentation:\nhttps://devforum.roblox.com/t/-/4026195",
	IsContainer = true,
	FontSize = "Body",
	Parent = mainPage,
})

docsLink.ClearTextOnFocus = false
docsLink.TextEditable = false

Navigation.SetPage(mainPage)

return mainPage