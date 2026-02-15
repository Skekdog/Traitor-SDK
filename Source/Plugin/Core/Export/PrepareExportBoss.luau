local SerializationService = game:GetService("SerializationService")

local function PrepareExportBoss(boss: Instance): buffer
	boss = boss:Clone()

	boss:SetAttribute("AssetType", "Boss")

	return SerializationService:SerializeInstancesAsync({boss})
end

return PrepareExportBoss