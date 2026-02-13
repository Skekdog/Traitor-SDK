local SerializationService = game:GetService("SerializationService")

local function PrepareExportGamemode(gamemode: Instance): buffer
	gamemode = gamemode:Clone()

	return SerializationService:SerializeInstancesAsync({gamemode})
end

return PrepareExportGamemode