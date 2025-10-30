local ChangeHistoryService = game:GetService("ChangeHistoryService")
local FetchAsset = require("../../Lib/FetchAsset")
local Message = require("../../Lib/Message")

local REFERENCE_ID = 116031459660559

local function LoadReference(): ()
	local reference = FetchAsset(REFERENCE_ID)
	assert(reference, "Invalid reference")

	local identifier = ChangeHistoryService:TryBeginRecording("TT3-SDK-LoadReference", "TT3 SDK: Load Reference")
	if not identifier then
		return Message("Could not create history record")
	end

	local success, err: string = pcall(function()
		for _, child in reference:GetChildren() do
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
		Message("Failed to load reference: " .. err)
		ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Cancel)
		return
	end

	ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit)
	Message("Reference has been loaded!", "success")
end

return LoadReference