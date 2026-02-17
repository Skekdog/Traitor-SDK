local key: string?

local ulidAlphabet = string.split("0123456789ABCDEFGHJKMNPQRSTVWXYZ", "") -- sourced from https://github.com/ulid/spec

local Key = {}

function Key.Set(newKey: string): boolean
	if newKey == "" then
		return false
	end

	for _, char in string.split(newKey, "") do
		if not table.find(ulidAlphabet, char) then
			return false
		end
	end

	key = newKey

	return true
end

function Key.Get(): string?
	return key
end

return Key
