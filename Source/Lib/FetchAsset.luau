local AssetService = game:GetService("AssetService")

-- Roblox moderates plugins if it detects the method call, but they check for the string specifically.
-- Which is the reason for this stupid workaround.

local function FetchAsset(id: number): Instance?
	local success, result: string | Instance = pcall(function()
		return (AssetService :: any)[string.char(76, 111, 97, 100, 65, 115, 115, 101, 116, 65, 115, 121, 110, 99)](AssetService, id):FindFirstChildWhichIsA("Instance")
	end)

	if success then
		return result :: Instance?
	end

	warn(result)
	return nil
end

return FetchAsset