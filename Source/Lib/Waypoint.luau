local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Message = require("./Message")

local function Waypoint(name: string, operation: () -> ()): ()
	name = "TT3-SDK-" .. name
	local displayName = "TT3 SDK: " .. name

	local identifier = ChangeHistoryService:TryBeginRecording(name, displayName)
	if not identifier then
		Message("Failed to create undo waypoint. Try again in a few moments or re-open the place file.")
		return
	end

	local success, result = pcall(operation :: () -> string)
	if not success then
		Message(result)
	end

	ChangeHistoryService:FinishRecording(identifier, if success then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel)
end

return Waypoint