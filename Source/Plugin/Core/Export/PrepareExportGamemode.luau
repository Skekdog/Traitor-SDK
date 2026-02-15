local SerializationService = game:GetService("SerializationService")

local function PrepareExportGamemode(gamemode: Instance): buffer
	gamemode = gamemode:Clone()

	gamemode:SetAttribute("AssetType", "Gamemode")

	return SerializationService:SerializeInstancesAsync({gamemode})
end

return PrepareExportGamemode