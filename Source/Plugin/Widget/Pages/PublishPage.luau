local Selection = game:GetService("Selection")
local SerializationService = game:GetService("SerializationService")
local Message = require("../../../Lib/Message")
local Frame = require("../../../Lib/UI/Components/Frame")
local TextBox = require("../../../Lib/UI/Components/TextBox")
local TextButton = require("../../../Lib/UI/Components/TextButton")
local Prompt = require("../../../Lib/UI/Prompt")
local Waypoint = require("../../../Lib/Waypoint")
local PrepareExportBoss = require("../../Core/Export/PrepareExportBoss")
local Net = require("../../Core/Net")
local PrepareExportGamemode = require("../../Core/Export/PrepareExportGamemode")
local PrepareExportMap = require("../../Core/Export/PrepareExportMap")
local LoadBoss = require("../../Core/Load/LoadBoss")
local LoadGamemode = require("../../Core/Load/LoadGamemode")
local LoadMap = require("../../Core/Load/LoadMap")
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
			return Message(response.Result, "error")
		end

		local asset = SerializationService:DeserializeInstancesAsync(buffer.fromstring(response.Result))[1]
		local assetType = asset:GetAttribute("AssetType")

		if assetType == "Map" then
			LoadMap(asset)
		elseif assetType == "Gamemode" then
			LoadGamemode(asset)
		elseif assetType == "Boss" then
			LoadBoss(asset)
		else
			Waypoint("LoadAsset", function()
				asset.Parent = workspace
				Message("Asset has been loaded! You may find it in Workspace.", "success")
			end)
		end
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
			data = PrepareExportBoss(asset)
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

function PublishingPage.Refresh(): ()
	local assets = Net.GetAvailableAssets()

	for _, button in assetsFrame:GetChildren() do
		if button.Name:sub(1, 6) == "Asset_" then
			button:Destroy()
		end
	end

	for _, asset in assets do
		addAssetButton(asset, tryPublish)
	end
end

TextButton({
	Name = "RefreshButton",
	Parent = assetsFrame,
	AutomaticSize = Enum.AutomaticSize.Y,

	FontSize = "Button",
	Text = "Refresh",

	LayoutOrder = 100000 - 1
}).Activated:Connect(PublishingPage.Refresh)

TextButton({
	Name = "NewAssetButton",
	Parent = assetsFrame,

	AutomaticSize = Enum.AutomaticSize.Y,

	FontSize = "Button",
	Text = "+",

	LayoutOrder = 100000,
}).Activated:Connect(function()
	Prompt(Widget.Widget, "Upload", "Are you sure you want to upload a new asset?", function(response)
		if response == "Cancel" then
			return
		end

		tryPublish()
	end)
end)



return PublishingPage
