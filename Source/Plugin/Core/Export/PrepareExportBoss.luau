local SerializationService = game:GetService("SerializationService")

local function PrepareExportBoss(boss: Instance): buffer
	boss = boss:Clone()

	return SerializationService:SerializeInstancesAsync({boss})
end

return PrepareExportBoss