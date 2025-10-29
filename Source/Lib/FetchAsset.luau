
local function FetchAsset(id: number): Instance?
	local success, result: string | Instance = pcall(function()
		return game:GetObjects("rbxassetid://" .. id)[1]
	end)

	if success then
		return result :: Instance?
	end

	warn(result)
	return nil
end

return FetchAsset