local ChangeHistoryService = game:GetService("ChangeHistoryService")
local FetchAsset = require("../../Lib/FetchAsset")
local Message = require("../../Lib/Message")

local REFERENCE_ID = 116031459660559

local function LoadReference(): ()
	local template = FetchAsset(REFERENCE_ID)
	assert(template, "Invalid template")

	local identifier = ChangeHistoryService:TryBeginRecording("TT3-SDK-LoadReference", "TT3 SDK: Load Reference")
	if not identifier then
		return Message("Could not create history record")
	end

	local success, err: string = pcall(function()
		for _, child in template:GetChildren() do
			local service = game:GetService(child.Name)

			for _, object in service:GetChildren() do
				object.Parent = nil
			end

			for _, object in child:GetChildren() do
				local clone = object:Clone()
				clone.Parent = service
			end
		end
	end, "")

	if not success then
		Message("Failed to load template: " .. err)
		ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Cancel)
		return
	end

	ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit)
end

return LoadReference