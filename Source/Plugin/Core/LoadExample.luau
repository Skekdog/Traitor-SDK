local ChangeHistoryService = game:GetService("ChangeHistoryService")
local FetchAsset = require("../../Lib/FetchAsset")

local LoadExample = {}

function LoadExample.Map(id: number): ()
	local identifier = ChangeHistoryService:TryBeginRecording("TT3-SDK-LoadMap", "TT3 SDK: Load Map")
	if not identifier then
		return warn("Could not create history record")
	end

	local asset = FetchAsset(id)
	if not asset then
		return warn("Invalid map")
	end

	asset.Name = "Map"
	asset.Parent = workspace
	ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit)
end

function LoadExample.Gamemode(id: number): ()
	local identifier = ChangeHistoryService:TryBeginRecording("TT3-SDK-LoadGamemode", "TT3 SDK: Load Gamemode")
	if not identifier then
		return warn("Could not create history record")
	end

	local asset = FetchAsset(id)
	if not asset then
		return warn("Invalid gamemode")
	end

	asset.Parent = workspace
	ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit)
end

return LoadExample