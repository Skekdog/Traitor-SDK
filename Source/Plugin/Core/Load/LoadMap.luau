local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local NilClearChildren = require("../../../Lib/NilClearChildren")
local Waypoint = require("../../../Lib/Waypoint")

local function LoadMap(map: Instance): ()
	Waypoint("LoadMap", function()
		for _, child in workspace:GetChildren() do
			pcall(function()
				child.Parent = nil
			end)
		end

		local gravity = map:GetAttribute("Gravity") or 50
		assert(typeof(gravity) == "number", "Expected Gravity to be a number")

		workspace.Gravity = gravity

		NilClearChildren(MaterialService)

		local materials = map:FindFirstChild("MaterialVariants")
		if materials then
			for _, child in materials:GetChildren() do
				child.Parent = MaterialService
			end
		end

		NilClearChildren(Lighting)

		local lightingSettings = map:FindFirstChild("LightingSettings")
		if lightingSettings then
			for i, v in lightingSettings:GetAttributes() do
				(Lighting :: any)[i] = v
			end

			for _, child in lightingSettings:GetChildren() do
				child.Parent = Lighting
			end
		end

		local terrain = map:FindFirstChild("Terrain")
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

		local waterSettings = map:FindFirstChild("WaterSettings")
		if waterSettings then
			for k, v in waterSettings:GetAttributes() do
				(workspace.Terrain :: any)[k] = v
			end
		end

		local terrainColors = map:FindFirstChild("TerrainColors")
		if terrainColors then
			for k, v in terrainColors:GetAttributes() do
				assert(typeof(v) == "Color3", "Terrain color must be a Color3")

				local material = Enum.Material:FromName(k)
				assert(material, "Invalid material name " .. k)

				workspace.Terrain:SetMaterialColor(material, v)
			end
		end

		map.Parent = workspace
	end)
end

return LoadMap