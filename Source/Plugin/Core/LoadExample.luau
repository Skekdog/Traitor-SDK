local ChangeHistoryService = game:GetService("ChangeHistoryService")
local FetchAsset = require("../../Lib/FetchAsset")

local LoadExample = {}

function LoadExample.Map(id: number): ()
	local identifier = ChangeHistoryService:TryBeginRecording("TT3-SDK-LoadMap", "TT3 SDK: Load Map")
	if not identifier then
		return
	end
	local asset = FetchAsset(id)
	asset.Name = "Map"
	asset.Parent = workspace
	ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit)
end

function LoadExample.Gamemode(id: number): ()
	local identifier = ChangeHistoryService:TryBeginRecording("TT3-SDK-LoadGamemode", "TT3 SDK: Load Gamemode")
	if not identifier then
		return
	end
	local asset = FetchAsset(id)
	asset.Parent = workspace
	ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit)
end

return LoadExample