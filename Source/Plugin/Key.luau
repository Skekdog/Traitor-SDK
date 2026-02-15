local EncodingService = game:GetService("EncodingService")

local key: string?

local Key = {}

function Key.Set(newKey: string): boolean
	if newKey == "" then
		return false
	end

	local success = pcall(EncodingService.Base64Decode, EncodingService, buffer.fromstring(newKey))
	if not success then
		return false
	end

	key = newKey

	return true
end

function Key.Get(): string?
	return key
end

return Key
