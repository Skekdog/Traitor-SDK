local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local Players = game:GetService("Players")
local StudioService = game:GetService("StudioService")
local PrepareSounds = require("./PrepareSounds")

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
end

local waterProperties = {
	"WaterColor",
	"WaterTransparency",
	"WaterWaveSpeed",
	"WaterWaveSize",
	"WaterReflectance"
}

local function waterSettings(map: Instance): ()
	removeOld(map, "WaterSettings")

	local folder = Instance.new("Configuration")
	folder.Name = "WaterSettings"

	for _, property in waterProperties do
		folder:SetAttribute(property, (workspace.Terrain :: {[string]: any})[property])
	end

	folder.Parent = map
end

-- Awaiting ReflectionService 🙏
local lightingProperties = {
	"ClockTime",
	"ColorShift_Bottom",
	"FogColor",
	"FogEnd",
	"EnvironmentDiffuseScale",
	"EnvironmentSpecularScale",
	"GlobalShadows",
	"FogStart",
	"Ambient",
	"OutdoorAmbient",
	"GeographicLatitude",
	"Brightness",
	"ColorShift_Top",
	"ExposureCompensation",
}

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

local function defaultAttributes(map: Instance): ()
	if not map:GetAttribute("Authors") then
		local success, username: string = pcall(Players.GetNameFromUserIdAsync, Players, StudioService:GetUserId())
		map:SetAttribute("Authors", if success then "@" .. username else "unknown author")
	end

	if not map:GetAttribute("Description") then
		map:SetAttribute("Description", "No description")
	end
end

local function PrepareExportMap(map: Instance): ()
	PrepareSounds(map)
	terrainRegion(map)
	terrainColors(map)
	waterSettings(map)
	lightingSettings(map)
	materials(map)
	gravity(map)
	defaultAttributes(map)
end

return PrepareExportMap