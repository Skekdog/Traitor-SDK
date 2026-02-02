local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local FetchAsset = require("../../Lib/FetchAsset")
local Message = require("../../Lib/Message")
local NilClearChildren = require("../../Lib/NilClearChildren")
local Prompt = require("../../Lib/UI/Prompt")
local Waypoint = require("../../Lib/Waypoint")
local Widget = require("../Widget")
local LoadScripts = require("./Smuggle/LoadScripts")

local LoadExample = {}

function LoadExample.Map(id: number): ()
	local response: "Cancel" | "OK"?
	Prompt(Widget.Widget, "Warning", "This will overwrite your entire game!", function(res)
		response = res
	end)

	while not response do
		task.wait()
	end

	if response ~= "OK" then
		return
	end

	Waypoint("LoadMap", function()
		local asset = FetchAsset(id)
		assert(asset, "Invalid map")

		for _, child in workspace:GetChildren() do
			pcall(function()
				child.Parent = nil
			end)
		end

		local gravity = asset:GetAttribute("Gravity") or 50
		assert(typeof(gravity) == "number", "Expected Gravity to be a number")

		workspace.Gravity = gravity

		NilClearChildren(MaterialService)

		local materials = asset:FindFirstChild("MaterialVariants")
		if materials then
			for _, child in materials:GetChildren() do
				child.Parent = MaterialService
			end
		end

		NilClearChildren(Lighting)

		local lightingSettings = asset:FindFirstChild("LightingSettings")
		if lightingSettings then
			for i, v in lightingSettings:GetAttributes() do
				(Lighting :: any)[i] = v
			end

			for _, child in lightingSettings:GetChildren() do
				child.Parent = Lighting
			end
		end

		local terrain = asset:FindFirstChild("Terrain")
		assert(not terrain or terrain:IsA("TerrainRegion"), "Expected Terrain to be a TerrainRegion")

		NilClearChildren(workspace.Terrain)
		workspace.Terrain:Clear()

		if terrain then
			workspace.Terrain:PasteRegion(terrain, Vector3int16.new(-32000, -32000, -32000), true)

			local clouds = terrain:FindFirstChild("Clouds")
			if clouds then
				clouds.Parent = workspace.Terrain
			end
		end

		local waterSettings = asset:FindFirstChild("WaterSettings")
		if waterSettings then
			for k, v in waterSettings:GetAttributes() do
				(workspace.Terrain :: any)[k] = v
			end
		end

		local terrainColors = asset:FindFirstChild("TerrainColors")
		if terrainColors then
			for k, v in terrainColors:GetAttributes() do
				assert(typeof(v) == "Color3", "Terrain color must be a Color3")

				local material = Enum.Material:FromName(k)
				assert(material, "Invalid material name " .. k)

				workspace.Terrain:SetMaterialColor(material, v)
			end
		end

		asset = LoadScripts(asset)

		asset.Parent = workspace
	end)
end

function LoadExample.Gamemode(id: number): ()
	Waypoint("LoadGamemode", function()
		local asset = FetchAsset(id)
		assert(asset, "Invalid gamemode")

		asset = LoadScripts(asset)

		asset.Parent = workspace

		Message("Gamemode has been loaded! You may find it in Workspace.", "success")
	end)
end

function LoadExample.Items(id: number): ()
	Waypoint("LoadItems", function()
		local asset = FetchAsset(id)
		if not asset then
			return Message("Failed to fetch items")
		end

		local success, err = pcall(function()
			asset.Parent = workspace
			return ""
		end)

		if not success then
			Message(err)
		end
	end)

	Message("Items have been loaded! You may find them in Workspace.", "success")
end

return LoadExample