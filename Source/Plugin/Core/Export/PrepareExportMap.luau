local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local Players = game:GetService("Players")
local ReflectionService = game:GetService("ReflectionService")
local SerializationService = game:GetService("SerializationService")
local StudioService = game:GetService("StudioService")

local METADATA_SOURCE = [[
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.API.Types)

local metadata: Types.MapMetadata = {
	DisplayName = nil,
	Description = "No description",
	Authors = "[AUTHORS]",
	Icon = Content.none,
}

return metadata
]]

local function removeOld(map: Instance, name: string): ()
	local old = map:FindFirstChild(name)
	if old then
		old.Parent = nil
	end
end

local function terrainRegion(map: Instance): ()
	removeOld(map, "Terrain")

	local region = workspace.Terrain:CopyRegion(Region3int16.new(Vector3int16.new(-32000, -32000, -32000), Vector3int16.new(32000, 32000, 32000)))
	region.Name = "Terrain"

	region.Parent = map
end

local function terrainColors(map: Instance): ()
	removeOld(map, "TerrainColors")

	local folder = Instance.new("Configuration")
	folder.Name = "TerrainColors"

	for _, material in Enum.Material:GetEnumItems() do
		pcall(function() -- pcall because some materials are invalid for terrain and throw errors
			folder:SetAttribute(material.Name, workspace.Terrain:GetMaterialColor(material))
		end)
	end

	folder.Parent = map
end

local function getAllProperties(class: string): {string}
	local properties: {string} = {}

	for _, property in ReflectionService:GetPropertiesOfClass(class, {ExcludeInherited = true, ExcludeDisplay = true}) do
		if property.Permits.Read and property.Permits.Write then
			table.insert(properties, property.Name)
		end
	end

	return properties
end

local lightingProperties = getAllProperties("Lighting")
local terrainProperties = getAllProperties("Terrain")

local function terrainSettings(map: Instance): ()
	removeOld(map, "WaterSettings")

	local folder = Instance.new("Configuration")
	folder.Name = "WaterSettings"

	for _, property in terrainProperties do
		folder:SetAttribute(property, (workspace.Terrain :: {[string]: any})[property])
	end

	folder.Parent = map
end

local function lightingSettings(map: Instance): ()
	removeOld(map, "LightingSettings")

	local folder = Instance.new("Configuration")
	folder.Name = "LightingSettings"

	for _, child in Lighting:GetChildren() do
		child:Clone().Parent = folder
	end

	for _, property in lightingProperties do
		folder:SetAttribute(property, (Lighting :: {[string]: any})[property])
	end

	folder.Parent = map
end

local function clouds(map: Instance): ()
	removeOld(map, "Clouds")

	local foundClouds = workspace.Terrain:FindFirstChildWhichIsA("Clouds")
	if foundClouds then
		local new = foundClouds:Clone()
		new.Name = "Clouds"
		new.Parent = map
	end
end

local function materials(map: Instance): ()
	removeOld(map, "MaterialVariants")

	local variants = MaterialService:GetChildren()
	if #variants == 0 then
		return
	end

	local folder = Instance.new("Configuration")
	folder.Name = "MaterialVariants"

	for _, material in variants do
		material:Clone().Parent = folder
	end

	folder.Parent = map
end

local function gravity(map: Instance): ()
	map:SetAttribute("Gravity", workspace.Gravity)
end

local function defaultMetadata(map: Instance): ()
	if map:FindFirstChild("Metadata") then
		return
	end

	local success, username: string = pcall(Players.GetNameFromUserIdAsync, Players, StudioService:GetUserId())
	local authors = if success then "@" .. username else "unknown author"

	local metadataModule = Instance.new("ModuleScript")
	metadataModule.Name = "Metadata"
	metadataModule.Source = METADATA_SOURCE:gsub("%[AUTHORS]", authors)
	metadataModule.Parent = map
end

local function PrepareExportMap(map: Instance): buffer
	map = map:Clone()

	terrainRegion(map)
	terrainColors(map)
	terrainSettings(map)
	clouds(map)
	lightingSettings(map)
	materials(map)
	gravity(map)
	defaultMetadata(map)

	map:SetAttribute("AssetType", "Map")

	return SerializationService:SerializeInstancesAsync({map})
end

return PrepareExportMap