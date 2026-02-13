local Selection = game:GetService("Selection")
local SerializationService = game:GetService("SerializationService")
local Message = require("../../../Lib/Message")
local Frame = require("../../../Lib/UI/Components/Frame")
local TextBox = require("../../../Lib/UI/Components/TextBox")
local TextButton = require("../../../Lib/UI/Components/TextButton")
local Prompt = require("../../../Lib/UI/Prompt")
local Waypoint = require("../../../Lib/Waypoint")
local Net = require("../../Core/Net")
local PrepareExportGamemode = require("../../Core/PrepareExportGamemode")
local PrepareExportMap = require("../../Core/PrepareExportMap")
local Widget = require("./..")

local PublishingPage = {}

PublishingPage.Mode = "Map" :: "Map" | "Gamemode" | "Boss"

local publishing = Frame({
	Name = "Publishing",
	Parent = Widget.Pages,
	IsContainer = true,

	Padding = 5,
})

PublishingPage.Page = publishing

local assetsFrame = Frame({
	Name = "Assets",
	Parent = publishing,

	IsContainer = true,
	Padding = 5,
})

do
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = assetsFrame
end

local function addAssetButton(asset: number, tryPublish: (number) -> ()): ()
	local frame = Frame({
		Name = "Asset_" .. asset,
		Parent = assetsFrame,

		AutomaticSize = Enum.AutomaticSize.Y,

		Padding = {
			Left = 8,
		},
	})

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 8)
	listLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.Parent = frame

	local label = TextBox({
		Name = "Label",
		Parent = frame,

		AutomaticSize = Enum.AutomaticSize.Y,

		NoStroke = true,

		Text = tostring(asset),
		FontSize = "Button",
		TextXAlignment = Enum.TextXAlignment.Left,

		LayoutOrder = 0,
	})

	label.TextEditable = false
	label.ClearTextOnFocus = false

	local flexItem = Instance.new("UIFlexItem")
	flexItem.FlexMode = Enum.UIFlexMode.Fill
	flexItem.Parent = label

	TextButton({
		Text = "Overwrite",
		FontSize = "Button",
		AutomaticSize = Enum.AutomaticSize.XY,

		AnchorPoint = Vector2.xAxis,
		Position = UDim2.fromScale(1, 0),

		Padding = {
			Left = 5,
			Right = 5,
		},

		Name = "OverwriteButton",
		Parent = frame,

		LayoutOrder = 1,
	}).Activated:Connect(function()
		Prompt(Widget.Widget, "Overwrite", "Are you sure you want to overwrite " .. asset .. "?", function(response)
			if response == "Cancel" then
				return
			end

			tryPublish(asset)
		end)
	end)

	TextButton({
		Text = "Load",
		FontSize = "Button",
		AutomaticSize = Enum.AutomaticSize.XY,

		AnchorPoint = Vector2.xAxis,

		Name = "LoadButton",
		Parent = frame,

		LayoutOrder = 2,

		Padding = {
			Left = 5,
			Right = 5,
		}
	}).Activated:Connect(function()
		local response = Net.FetchAssetContent(asset)
		if not response.Success then
			return warn(response.Result)
		end

		SerializationService:DeserializeInstancesAsync(buffer.fromstring(response.Result))[1].Parent = workspace
	end)
end

local function tryPublish(assetId: number?): ()
	local selection = Selection:Get()
	if #selection ~= 1 then
		Message("Please select exactly one instance to publish.")
		return
	end

	Waypoint("PublishAsset", function()
		local asset = selection[1]

		if asset.Name == "Map" then
			Message("Ensure map name is correctly set before publishing.")
			return
		end

		local data: buffer
		if PublishingPage.Mode == "Map" then
			data = PrepareExportMap(asset)
		elseif PublishingPage.Mode == "Gamemode" then
			data = PrepareExportGamemode(asset)
		elseif PublishingPage.Mode == "Boss" then
			data = buffer.create(1)
		end

		local response
		if assetId then
			response = Net.UpdateAsset(data, assetId)
		else
			response = Net.CreateAsset(data)
		end

		if not response.Success then
			return Message("Failed to upload: " .. response.Result, "error")
		end

		Message("Uploaded! You may load this in Labs.", "success")

		if not assetId then
			addAssetButton(response.Result :: number, tryPublish)
		end
	end)
end

TextButton({
	Name = "NewAssetButton",
	Parent = assetsFrame,

	AutomaticSize = Enum.AutomaticSize.Y,

	FontSize = "Button",
	Text = "+",

	LayoutOrder = 100000,
}).Activated:Connect(function()
	Prompt(Widget.Widget, "Overwrite", "Are you sure you want to upload a new asset?", function(response)
		if response == "Cancel" then
			return
		end

		tryPublish()
	end)
end)

task.spawn(function()
	local assets = Net.GetAvailableAssets()

	while #assets == 0 do
		task.wait(1)
		assets = Net.GetAvailableAssets()
	end

	for _, asset in assets do
		addAssetButton(asset, tryPublish)
	end
end)

return PublishingPage
