local ChangeHistoryService = game:GetService("ChangeHistoryService")
local FetchAsset = require("../../Lib/FetchAsset")
local Message = require("../../Lib/Message")

local LoadExample = {}

function LoadExample.Map(id: number): ()
	local identifier = ChangeHistoryService:TryBeginRecording("TT3-SDK-LoadMap", "TT3 SDK: Load Map")
	if not identifier then
		return Message("Could not create history record")
	end

	local asset = FetchAsset(id)
	if not asset then
		return Message("Invalid map")
	end

	local success, err = pcall(function()
		asset.Name = "Map"
		asset.Parent = workspace
		return ""
	end)

	if not success then
		Message(err)
	end

	ChangeHistoryService:FinishRecording(identifier, if success then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel)
end

function LoadExample.Gamemode(id: number): ()
	local identifier = ChangeHistoryService:TryBeginRecording("TT3-SDK-LoadGamemode", "TT3 SDK: Load Gamemode")
	if not identifier then
		return Message("Could not create history record")
	end

	local asset = FetchAsset(id)
	if not asset then
		return Message("Invalid gamemode")
	end

	local success, err = pcall(function()
		asset.Parent = workspace
		return ""
	end)

	if not success then
		Message(err)
	end

	ChangeHistoryService:FinishRecording(identifier, if success then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel)
end

return LoadExample